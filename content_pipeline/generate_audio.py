import json
import os
import asyncio
from gtts import gTTS

INPUT_DIR = 'output'
AUDIO_OUTPUT_DIR = 'output/audio'

if not os.path.exists(AUDIO_OUTPUT_DIR):
    os.makedirs(AUDIO_OUTPUT_DIR)

async def generate_audio_for_unit(unit_filename):
    filepath = os.path.join(INPUT_DIR, unit_filename)
    if not os.path.exists(filepath):
        print(f"File not found: {filepath}. Skipping.")
        return

    print(f"Reading {filepath}...")
    with open(filepath, 'r', encoding='utf-8') as f:
        data = json.load(f)

    lessons = data.get('lessons', [])
    updated_lessons = []

    for lesson in lessons:
        print(f"Processing lesson: {lesson.get('title', 'Unknown')}")
        content_json = lesson.get('content', [])
        
        if lesson.get('type') == 'DIALOGUE':
            for idx, line in enumerate(content_json):
                text = line['es']
                # gTTS doesn't support specific named voices like Edge TTS.
                # We use 'es' lang. We can vary 'tld' for accent if we really want distinction,
                # e.g., 'es' (Spain) vs 'com.mx' (Mexico).
                # For now, simpler is better.
                
                # Generate filename
                safe_text = "".join([c for c in text if c.isalnum() or c in (' ','_')]).strip().replace(" ", "_")[:30]
                filename = f"{lesson.get('lesson_id', 'unknown')}_{idx}_{safe_text}.mp3"
                output_path = os.path.join(AUDIO_OUTPUT_DIR, filename)
                
                if not os.path.exists(output_path):
                    print(f"  Generating (gTTS): {text[:20]}... -> {filename}")
                    try:
                        # Run gTTS in a thread/executor to not block the loop (though script is linear anyway)
                        # Simple synchronous call:
                        tts = gTTS(text=text, lang='es')
                        tts.save(output_path)
                    except Exception as e:
                        print(f"    Error generating audio: {e}")
                        # Fallback: Create a dummy file
                        with open(output_path, 'wb') as f:
                            f.write(b'ID3\x03\x00\x00\x00\x00\x00\x00') 
                
                # Update reference
                line['audio_ref'] = f"https://espanol-pro-content.xamide.workers.dev/{filename}"
        
        updated_lessons.append(lesson)

    # Generate SQL Update Script
    sql_output_path = 'backend/scripts/update_audio_v3.sql'
    
    os.makedirs(os.path.dirname(sql_output_path), exist_ok=True)
    
    with open(sql_output_path, 'a', encoding='utf-8') as f:
        for lesson in updated_lessons:
            if lesson.get('type') == 'DIALOGUE':
                content_str = json.dumps(lesson['content'], ensure_ascii=False)
                content_str = content_str.replace("'", "''")
                
                lesson_id = lesson.get('lesson_id')
                if lesson_id:
                    f.write(f"-- Update audio for {lesson.get('title')}\n")
                    f.write(f"UPDATE lessons SET content_json = '{content_str}' WHERE id = '{lesson_id}';\n\n")
    
    print(f"Appended SQL updates to {sql_output_path}")

async def main():
    # Clear previous SQL file if it exists
    sql_output_path = 'backend/scripts/update_audio_v3.sql'
    if os.path.exists(sql_output_path):
        os.remove(sql_output_path)
        
    await generate_audio_for_unit('fsi_unit_1.json')
    await generate_audio_for_unit('fsi_unit_2.json')

if __name__ == "__main__":
    asyncio.run(main())
