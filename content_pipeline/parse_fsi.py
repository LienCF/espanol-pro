import json
import os

OUTPUT_DIR = 'output'

def generate_fsi_unit_2():
    """
    Generates content for FSI Spanish Basic Unit 2 (Greetings & Introductions).
    """
    unit_data = {
        "unit_id": "u2",
        "title": "Unit 2: Meeting People",
        "lessons": [
            {
                "lesson_id": "l2_1_dialogue",
                "title": "Dialogue: At the Office",
                "type": "DIALOGUE",
                "order_index": 1,
                "content": [
                    {
                        "speaker": "Sr. Adams",
                        "es": "Buenas tardes, señor.",
                        "en": "Good afternoon, sir.",
                        "audio_ref": "https://actions.google.com/sounds/v1/crowds/female_crowd_celebration.ogg" 
                    },
                    {
                        "speaker": "Sr. Molina",
                        "es": "Buenas tardes. ¿Es usted el señor Adams?",
                        "en": "Good afternoon. Are you Mr. Adams?",
                        "audio_ref": "https://actions.google.com/sounds/v1/crowds/male_crowd_celebration.ogg"
                    },
                    {
                        "speaker": "Sr. Adams",
                        "es": "Sí, señor. Y usted es el señor Molina, ¿verdad?",
                        "en": "Yes, sir. And you are Mr. Molina, right?",
                        "audio_ref": "https://actions.google.com/sounds/v1/ambiences/coffee_shop.ogg"
                    },
                    {
                        "speaker": "Sr. Molina",
                        "es": "Sí, señor. Mucho gusto.",
                        "en": "Yes, sir. Nice to meet you.",
                        "audio_ref": "https://actions.google.com/sounds/v1/crowds/female_crowd_celebration.ogg"
                    },
                    {
                        "speaker": "Sr. Adams",
                        "es": "El gusto es mío.",
                        "en": "The pleasure is mine.",
                        "audio_ref": "https://actions.google.com/sounds/v1/crowds/male_crowd_celebration.ogg"
                    }
                ]
            },
            {
                "lesson_id": "l2_2_drill",
                "title": "Drill: Ser (To be)",
                "type": "DRILL",
                "order_index": 2,
                "content": [
                    {"base": "Yo soy norteamericano.", "substitution": "Nosotros", "result": "Nosotros somos norteamericanos."},
                    {"base": "Nosotros somos norteamericanos.", "substitution": "Él", "result": "Él es norteamericano."},
                    {"base": "Él es norteamericano.", "substitution": "Ellos", "result": "Ellos son norteamericanos."},
                    {"base": "Ellos son norteamericanos.", "substitution": "Ella", "result": "Ella es norteamericana."}
                ]
            },
            {
                "lesson_id": "l2_3_quiz",
                "title": "Unit 2 Quiz",
                "type": "QUIZ",
                "order_index": 3,
                "content": [
                    {
                        "question": "How do you say 'Nice to meet you'?",
                        "options": ["Por favor", "Mucho gusto", "Buenas tardes", "Perdón"],
                        "correctIndex": 1
                    },
                    {
                        "question": "Which verb form is used for 'We are'?",
                        "options": ["Soy", "Es", "Somos", "Son"],
                        "correctIndex": 2
                    },
                    {
                        "question": "Translate: 'Are you Mr. Adams?'",
                        "options": ["¿Es usted el señor Adams?", "¿Soy yo el señor Adams?", "¿Cómo está el señor Adams?", "Hola señor Adams"],
                        "correctIndex": 0
                    }
                ]
            }
        ]
    }

    if not os.path.exists(OUTPUT_DIR):
        os.makedirs(OUTPUT_DIR)

    output_path = os.path.join(OUTPUT_DIR, 'fsi_unit_2.json')
    with open(output_path, 'w', encoding='utf-8') as f:
        json.dump(unit_data, f, indent=2, ensure_ascii=False)
    
    print(f"Generated content at {output_path}")

if __name__ == "__main__":
    generate_fsi_unit_2()
