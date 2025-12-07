import re
import json

# 模擬 FSI PDF 中的原始文本 (OCR 結果)
raw_ocr_text = """
UNIT 1 - BASIC SENTENCES

A: Buenos días.                    Good morning.
B: Buenos días, señor.             Good morning, sir.
A: ¿Cómo está usted?               How are you?
B: Muy bien, gracias. ¿Y usted?    Very well, thank you. And you?

DRILL 1.1 - SUBSTITUTION
(Instructor says base sentence, student repeats with substitution)

1. Yo voy al banco. (al hotel)
   Yo voy al hotel.

2. Yo voy al hotel. (a la tienda)
   Yo voy a la tienda.

3. Yo voy a la tienda. (al mercado)
   Yo voy al mercado.

DRILL 1.2 - CORRELATION
1. ¿Trabaja usted aquí? (él)
   ¿Trabaja él aquí?

2. ¿Trabaja él aquí? (ella)
   ¿Trabaja ella aquí?
"""

def parse_fsi_content(text):
    lessons = []
    
    # 1. Parse Dialogues
    dialogue_match = re.search(r'BASIC SENTENCES\n\n(.*?)\n\nDRILL', text, re.DOTALL)
    if dialogue_match:
        dialogue_raw = dialogue_match.group(1)
        lines = []
        for line in dialogue_raw.strip().split('\n'):
            # Regex to capture "Speaker: Spanish   English"
            # Handles A: or B: prefix
            match = re.match(r'([A-B]):\s+(.*?)\s{2,}(.*)', line)
            if match:
                lines.append({
                    "speaker": match.group(1),
                    "es": match.group(2).strip(),
                    "en": match.group(3).strip()
                })
        
        lessons.append({
            "title": "Basic Sentences",
            "type": "DIALOGUE",
            "content": lines
        })

    # 2. Parse Substitution Drills
    # Finds blocks starting with "DRILL X - SUBSTITUTION"
    drill_matches = re.finditer(r'DRILL (\d+\.\d+) - (SUBSTITUTION|CORRELATION)\n(.*?)(?=\n\nDRILL|\Z)', text, re.DOTALL)
    
    for match in drill_matches:
        drill_id = match.group(1)
        drill_type = match.group(2)
        drill_body = match.group(3)
        
        items = []
        # Heuristic: Look for patterns like "1. Base (Sub) \n Result"
        # This regex looks for: Number. Sentence (Sub) \n Sentence
        item_pattern = re.findall(r'\d+\.\s+(.*?)\s+\((.*?)\)\n\s+(.*)', drill_body)
        
        for base, sub, result in item_pattern:
            items.append({
                "base": base.strip(),
                "substitution": sub.strip(),
                "result": result.strip()
            })
            
        if items:
            lessons.append({
                "title": f"{drill_type.title()} Drill {drill_id}",
                "type": "DRILL",
                "content": items
            })

    return lessons

# 執行解析
parsed_data = parse_fsi_content(raw_ocr_text)

# 輸出結果
print(json.dumps(parsed_data, indent=2, ensure_ascii=False))
