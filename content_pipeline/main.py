import json
import os

RAW_DATA_DIR = 'raw_data'
OUTPUT_DIR = 'output'

def generate_mock_fsi_json():
    """
    Generates a JSON structure mimicking what we would extract from FSI Unit 1.
    """
    unit_data = {
        "unit_id": "u1",
        "title": "Unit 1: The Basics",
        "lessons": [
            {
                "lesson_id": "l1",
                "title": "Basic Sentences",
                "type": "DIALOGUE",
                "content": [
                    {"speaker": "A", "es": "Buenos días.", "en": "Good morning.", "audio_ref": "u1_l1_01.mp3"},
                    {"speaker": "B", "es": "Buenos días, señor.", "en": "Good morning, sir.", "audio_ref": "u1_l1_02.mp3"},
                    {"speaker": "A", "es": "¿Cómo está usted?", "en": "How are you?", "audio_ref": "u1_l1_03.mp3"}
                ]
            },
            {
                "lesson_id": "l2",
                "title": "Substitution Drill",
                "type": "DRILL",
                "content": [
                    {"base": "Yo voy al banco.", "substitution": "la tienda", "result": "Yo voy a la tienda."},
                    {"base": "Yo voy a la tienda.", "substitution": "el hotel", "result": "Yo voy al hotel."}
                ]
            }
        ]
    }
    
    if not os.path.exists(OUTPUT_DIR):
        os.makedirs(OUTPUT_DIR)

    output_path = os.path.join(OUTPUT_DIR, 'fsi_unit_1.json')
    with open(output_path, 'w', encoding='utf-8') as f:
        json.dump(unit_data, f, indent=2, ensure_ascii=False)
    
    print(f"Generated mock content at {output_path}")

if __name__ == "__main__":
    generate_mock_fsi_json()
