import asyncio
import os
import edge_tts
from generate_niche_content import intro_lessons, construction_lessons, tourism_lessons_u1, tourism_lessons_u2, business_lessons_u1, business_lessons_u2, ut_austin_lessons

OUTPUT_DIR = "output/audio"
BASE_URL = "https://pub-8e0f5e798a584c6c82ac79d7666911e3.r2.dev/audio"

# Voice Mapping
VOICE_ES_SPAIN = "es-ES-AlvaroNeural"
VOICE_ES_MEXICO = "es-MX-DaliaNeural"
VOICE_ES_ARGENTINA = "es-AR-TomasNeural"

async def generate_mp3(text, filename, voice):
    output_path = os.path.join(OUTPUT_DIR, filename)
    if os.path.exists(output_path):
        print(f"Skipping {filename} (exists)")
        return

    print(f"Generating {filename}...")
    communicate = edge_tts.Communicate(text, voice)
    await communicate.save(output_path)

async def main():
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    tasks = []

    # 1. Intro Module (A0)
    print("--- Processing Intro Module ---")
    for lesson in intro_lessons:
        for item in lesson["content"]:
            # Extract filename from the URL we defined in the content script
            if "audio" in item:
                url = item["audio"]
                filename = url.split("/")[-1]
                # Determine text to speak. For Flashcards: Front + Back. For Drill: Base + Result.
                if lesson["type"] == "FLASHCARD":
                    text = f"{item['front']}. {item['back']}. {item['example']}"
                elif lesson["type"] == "DRILL":
                    text = f"{item['base']}... {item['substitution']}... {item['result']}"
                else:
                    text = "Audio placeholder"
                
                tasks.append(generate_mp3(text, filename, VOICE_ES_SPAIN))

    # 2. Construction (OSHA) - Image Quiz Prompts
    print("--- Processing Construction ---")
    for lesson in construction_lessons:
        if "content" in lesson and isinstance(lesson["content"], list):
            for item in lesson["content"]:
                if "question_audio" in item:
                    url = item["question_audio"]
                    filename = url.split("/")[-1]
                    # Prompt text like "Seleccione: 'Use el casco'"
                    # Extract the quote part for cleaner audio
                    text = item["prompt"].replace("Seleccione: ", "")
                    tasks.append(generate_mp3(text, filename, VOICE_ES_MEXICO))

    # 3. Tourism (Dialogues)
    print("--- Processing Tourism ---")
    all_tourism = tourism_lessons_u1 + tourism_lessons_u2
    for lesson in all_tourism:
        if lesson["type"] == "DIALOGUE":
            for line in lesson["content"]:
                url = line["audio_ref"]
                filename = url.split("/")[-1]
                text = line["es"]
                # Simple logic: Vendor/Host = Mexico/Spain? Let's default to MX for Tacos, Spain for Airport
                voice = VOICE_ES_MEXICO if "tacos" in filename else VOICE_ES_SPAIN
                tasks.append(generate_mp3(text, filename, voice))

    # 4. Business (Dialogues & Quizzes)
    print("--- Processing Business ---")
    all_biz = business_lessons_u1 + business_lessons_u2
    for lesson in all_biz:
        if lesson["type"] == "DIALOGUE":
            for line in lesson["content"]:
                url = line["audio_ref"]
                filename = url.split("/")[-1]
                text = line["es"]
                tasks.append(generate_mp3(text, filename, VOICE_ES_SPAIN))

    # 5. UT Austin Simulation (Accents)
    print("--- Processing UT Austin ---")
    for lesson in ut_austin_lessons:
        for line in lesson["content"]:
            url = line["audio_ref"]
            filename = url.split("/")[-1]
            text = line["es"]
            
            voice = VOICE_ES_SPAIN
            if line["speaker"] == "Mexicano":
                voice = VOICE_ES_MEXICO
            elif line["speaker"] == "Argentino": # In case we added Argentina
                voice = VOICE_ES_ARGENTINA
            
            tasks.append(generate_mp3(text, filename, voice))

    # Run all
    await asyncio.gather(*tasks)
    print("Done! Audio files generated in output/audio/")

if __name__ == "__main__":
    asyncio.run(main())
