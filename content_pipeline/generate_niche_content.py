import json
import uuid

def escape_sql(text):
    return text.replace("'", "''")

# Helper to dump json with double quote escape for SQL
def json_sql(obj):
    return json.dumps(obj, ensure_ascii=False).replace("'", "''")

# Helper for localization
def loc(en, zh):
    return {"en": en, "zh": zh}

# --- Data Sources ---

# 0. Intro Module (A0)
intro_lessons = [
    {
        "title": loc("The Vowels (Las Vocales)", "母音 (Las Vocales)"),
        "type": "FLASHCARD",
        "kc": "kc_pronunciation_vowels",
        "content": [
            {
                "front": "A", 
                "back": loc("Sounds like 'a' in 'father'. Never like 'cat'.", "發音像 '爸爸' (baba) 中的 'a'。嘴巴張大。"),
                "example": "Agua (Water)", 
                "audio": "https://pub-8e0f5e798a584c6c82ac79d7666911e3.r2.dev/audio/intro_a.mp3"
            },
            {
                "front": "E", 
                "back": loc("Sounds like 'e' in 'bed'.", "發音像 '耶' (ye) 中的 'e'。嘴角向兩側咧開。"),
                "example": "Elefante (Elephant)", 
                "audio": "https://pub-8e0f5e798a584c6c82ac79d7666911e3.r2.dev/audio/intro_e.mp3"
            },
            {
                "front": "I", 
                "back": loc("Sounds like 'ee' in 'see'.", "發音像 '一' (yi)。"),
                "example": "Isla (Island)", 
                "audio": "https://pub-8e0f5e798a584c6c82ac79d7666911e3.r2.dev/audio/intro_i.mp3"
            },
            {
                "front": "O", 
                "back": loc("Sounds like 'o' in 'so'. Round your lips.", "發音像 '喔' (o)。嘴巴要圓。"),
                "example": "Oso (Bear)", 
                "audio": "https://pub-8e0f5e798a584c6c82ac79d7666911e3.r2.dev/audio/intro_o.mp3"
            },
            {
                "front": "U", 
                "back": loc("Sounds like 'oo' in 'moon'.", "發音像 '烏' (wu)。嘴唇噘起。"),
                "example": "Uvas (Grapes)", 
                "audio": "https://pub-8e0f5e798a584c6c82ac79d7666911e3.r2.dev/audio/intro_u.mp3"
            }
        ]
    },
    {
        "title": loc("Tricky Consonants", "易混淆子音"),
        "type": "DRILL",
        "kc": "kc_pronunciation_consonants",
        "content": [
            {"base": loc("Pero (But)", "Pero (但是)"), "substitution": loc("Perro (Dog)", "Perro (狗)"), "result": loc("Trill the RR!", "RR 要用力彈舌！"), "audio": "https://pub-8e0f5e798a584c6c82ac79d7666911e3.r2.dev/audio/intro_rr.mp3"},
            {"base": loc("Niño (Boy)", "Niño (男孩)"), "substitution": loc("Mañana (Tomorrow)", "Mañana (明天)"), "result": loc("N with tilde is 'ny'", "Ñ 發音像 '尼' (ni)"), "audio": "https://pub-8e0f5e798a584c6c82ac79d7666911e3.r2.dev/audio/intro_nye.mp3"},
            {"base": loc("Hola (Hello)", "Hola (你好)"), "substitution": loc("Hospital", "Hospital (醫院)"), "result": loc("H is always silent", "H 永遠不發音"), "audio": "https://pub-8e0f5e798a584c6c82ac79d7666911e3.r2.dev/audio/intro_h.mp3"}
        ]
    },
    {
        "title": loc("Stress Rules Quiz", "重音規則測驗"),
        "type": "QUIZ",
        "kc": "kc_stress_rules",
        "content": [
            {
                "question": loc("Where is the stress in 'Casa' (ends in vowel)?", "'Casa' (母音結尾) 的重音在哪裡？"),
                "options": [loc("Last syllable (sa)", "最後一個音節 (sa)"), loc("Second to last (Ca)", "倒數第二音節 (Ca)"), loc("First syllable", "第一個音節"), loc("Random", "隨機")],
                "correctIndex": 1
            },
            {
                "question": loc("Where is the stress in 'Hotel' (ends in consonant L)?", "'Hotel' (子音 L 結尾) 的重音在哪裡？"),
                "options": [loc("Last syllable (tel)", "最後一個音節 (tel)"), loc("First syllable (Ho)", "第一個音節 (Ho)"), loc("Middle", "中間"), loc("Silent", "不發音")],
                "correctIndex": 0
            }
        ]
    }
]

# 1. Construction (OSHA)
construction_lessons = [
    {
        "title": loc("Personal Protective Equipment (PPE)", "個人防護裝備 (PPE)"),
        "type": "IMAGE_QUIZ", 
        "kc": "kc_safety_imperatives",
        "content": [
            {
                "question_audio": "https://pub-8e0f5e798a584c6c82ac79d7666911e3.r2.dev/audio/osha_helmet.mp3", 
                "prompt": loc("Select: 'Use the helmet'", "請選擇：'戴上安全帽' (Use el casco)"),
                "options": [
                    {"id": "opt1", "text": loc("Helmet (Casco)", "安全帽 (Casco)"), "image": "assets/images/helmet.png", "correct": True},
                    {"id": "opt2", "text": loc("Gloves (Guantes)", "手套 (Guantes)"), "image": "assets/images/gloves.png", "correct": False},
                    {"id": "opt3", "text": loc("Boots (Botas)", "靴子 (Botas)"), "image": "assets/images/boots.png", "correct": False},
                    {"id": "opt4", "text": loc("Vest (Chaleco)", "背心 (Chaleco)"), "image": "assets/images/vest.png", "correct": False}
                ]
            },
            {
                "question_audio": "https://pub-8e0f5e798a584c6c82ac79d7666911e3.r2.dev/audio/osha_harness.mp3", 
                "prompt": loc("Select: 'Tie off the harness'", "請選擇：'繫好安全帶' (Amárrese el arnés)"),
                "options": [
                    {"id": "opt1", "text": loc("Harness (Arnés)", "安全帶 (Arnés)"), "image": "assets/images/harness.png", "correct": True},
                    {"id": "opt2", "text": loc("Ladder (Escalera)", "梯子 (Escalera)"), "image": "assets/images/ladder.png", "correct": False}
                ]
            }
        ]
    },
    {
        "title": loc("Fall Protection & Ladders", "墜落防護與梯子"),
        "type": "IMAGE_QUIZ",
        "kc": "kc_safety_imperatives",
        "content": [
            {
                "question_audio": "https://pub-8e0f5e798a584c6c82ac79d7666911e3.r2.dev/audio/osha_ladder_angle.mp3",
                "prompt": loc("Select: 'Keep ladder at correct angle'", "請選擇：'保持梯子正確角度'"),
                "options": [
                    {"id": "opt1", "text": loc("Correct Angle", "正確角度"), "image": "assets/images/ladder_correct.png", "correct": True},
                    {"id": "opt2", "text": loc("Flat on ground", "平放地面"), "image": "assets/images/ladder_flat.png", "correct": False}
                ]
            },
            {
                "question_audio": "https://pub-8e0f5e798a584c6c82ac79d7666911e3.r2.dev/audio/osha_no_step.mp3",
                "prompt": loc("Select: 'Do not step on the top rung'", "請選擇：'不要踩最後一階'"),
                "options": [
                    {"id": "opt1", "text": loc("Top Step (Unsafe)", "頂階 (不安全)"), "image": "assets/images/ladder_top_step.png", "correct": True},
                    {"id": "opt2", "text": loc("Middle Step", "中間階"), "image": "assets/images/ladder_mid_step.png", "correct": False}
                ]
            }
        ]
    },
    {
        "title": loc("Silica Dust Control", "矽粉塵控制"),
        "type": "READING",
        "kc": "kc_safety_imperatives",
        "content": {
            "text": "\n            CONTROL DE POLVO DE SÍLICE:\n            El polvo de sílice cristalina respirable se crea al cortar, aserrar, esmerilar, taladrar o triturar piedra, roca, hormigón, ladrillo, bloque y mortero.\n            \n            Medidas de control:\n            1. Use agua para suprimir el polvo (Corte húmedo).\n            2. Use aspiradoras con filtros HEPA.\n            3. Use respiradores (máscaras) si los controles de ingeniería no son suficientes.\n            \n            ¡El polvo de sílice causa silicosis, una enfermedad pulmonar incurable!\n            ",
            "questions": [
                {
                    "question": loc("What disease does silica dust cause?", "矽粉塵會導致什麼疾病？"),
                    "options": [loc("Flu", "流感"), loc("Silicosis", "矽肺病"), loc("Mild Asthma", "輕微氣喘"), loc("Headache", "頭痛")],
                    "correctIndex": 1
                },
                {
                    "question": loc("What is an effective control method?", "哪種控制方法有效？"),
                    "options": [loc("Blowing with air", "吹氣"), loc("Dry sweeping", "乾掃"), loc("Using water (Wet cutting)", "用水 (濕切)"), loc("Ignoring it", "忽略它")],
                    "correctIndex": 2
                }
            ]
        }
    }
]

# 2. Legal (Court Glossaries)
legal_lessons = [
    {
        "title": loc("Courtroom Roles", "法庭角色"),
        "type": "FLASHCARD", 
        "kc": "kc_legal_vocabulary",
        "content": [
            {
                "front": "El Juez", 
                "back": loc("The Judge", "法官"),
                "example": loc("The judge dictates the sentence.", "El juez dicta la sentencia. (法官宣判。)")
            },
            {
                "front": "El Abogado", 
                "back": loc("The Lawyer/Attorney", "律師"),
                "example": loc("The lawyer defends the accused.", "El abogado defiende al acusado. (律師為被告辯護。)")
            },
            {
                "front": "El Acusado", 
                "back": loc("The Defendant", "被告"),
                "example": loc("The defendant pleads innocent.", "El acusado se declara inocente. (被告抗辯無罪。)")
            },
            {
                "front": "El Fiscal", 
                "back": loc("The Prosecutor", "檢察官"),
                "example": loc("The prosecutor presents charges.", "El fiscal presenta los cargos. (檢察官提出指控。)")
            }
        ]
    },
    {
        "title": loc("Common Procedures", "常見程序"),
        "type": "QUIZ",
        "kc": "kc_legal_vocabulary",
        "content": [
            {
                "question": loc("Translate: 'Arraignment'", "翻譯：'Arraignment' (提審)"),
                "options": [loc("Lectura de cargos", "Lectura de cargos (提審)"), loc("Juicio", "Juicio (審判)"), loc("Sentencia", "Sentencia (判決)"), loc("Apelación", "Apelación (上訴)")],
                "correctIndex": 0
            },
            {
                "question": loc("What does 'Bajo juramento' mean?", "'Bajo juramento' 是什麼意思？"),
                "options": [loc("Under arrest", "被逮捕"), loc("Under oath", "宣誓下"), loc("Under investigation", "被調查"), loc("Underweight", "體重不足")],
                "correctIndex": 1
            }
        ]
    }
]

# 3. Digital Nomad (Visa)
nomad_lessons = [
    {
        "title": loc("Visa Requirements", "簽證要求"),
        "type": "READING",
        "kc": "kc_bureaucracy",
        "content": {
            "text": "\n            Para solicitar el visado de nómada digital, usted debe demostrar:\n            1. Que trabaja de forma remota para empresas fuera de España.\n            2. Que tiene ingresos suficientes (al menos 200% del SMI).\n            3. Que no tiene antecedentes penales en los últimos 5 años.\n            ",
            "questions": [
                {
                    "question": loc("What is the income requirement?", "收入要求是多少？"),
                    "options": ["100% of SMI", "200% of SMI", "No requirement", "5000 Euros"],
                    "correctIndex": 1
                },
                {
                    "question": loc("Can you work for a Spanish company primarily?", "可以主要為西班牙公司工作嗎？"),
                    "options": [loc("Yes", "可以"), loc("No, mostly outside Spain", "不行，主要需在西班牙境外"), loc("Only Spanish companies", "只能為西班牙公司"), loc("Whatever", "隨便")],
                    "correctIndex": 1
                }
            ]
        }
    }
]

# 4. Architecture History (C1/C2)
arch_lessons = [
    {
        "title": loc("Romanesque & Gothic Art", "羅馬式與哥德式藝術"),
        "type": "READING",
        "kc": "kc_arch_terms",
        "content": {
            "text": "\n            La arquitectura gótica española se caracteriza por la evolución desde el románico hacia estructuras más ligeras y luminosas.\n            \n            Elementos clave:\n            - Bóveda de crucería (Ribbed vault): Permite cubrir espacios más amplios.\n            - Arco apuntado (Pointed arch): Distribuye mejor el peso que el arco de medio punto románico.\n            - Arbotantes (Flying buttresses): Soportan el empuje de las bóvedas desde el exterior.\n            \n            En contraste, la arquitectura islámica en España (Al-Ándalus) introdujo el arco de herradura (Horseshoe arch) y el uso decorativo del alfiz.\n            ",
            "questions": [
                {
                    "question": loc("What element allows covering wider spaces?", "什麼元素允許覆蓋更寬的空間？"),
                    "options": ["Arco de medio punto", "Bóveda de crucería", "Muro grueso", "Columna dórica"],
                    "correctIndex": 1
                },
                {
                    "question": loc("What is an 'Arbotante'?", "'Arbotante' (飛扶壁) 是什麼？"),
                    "options": [loc("A type of tree", "一種樹"), loc("An exterior structural support", "外部結構支撐"), loc("A circular window", "圓形窗戶"), loc("A decorated door", "裝飾門")],
                    "correctIndex": 1
                },
                {
                    "question": loc("What arch is characteristic of Islamic architecture?", "伊斯蘭建築的特徵拱門是什麼？"),
                    "options": ["Arco apuntado", "Arco de herradura", "Arco plano", "Arco triunfal"],
                    "correctIndex": 1
                }
            ]
        }
    }
]

# 5. Tourism (A1/B1)
tourism_lessons_u1 = [
    {
        "title": loc("Airport Survival", "機場生存"),
        "type": "DIALOGUE",
        "kc": "kc_tourism_phrases",
        "content": [
            {"speaker": "Traveler", "es": "Perdón, ¿dónde está mi equipaje?", "translation": loc("Excuse me, where is my luggage?", "不好意思，我的行李在哪裡？"), "audio_ref": "https://pub-8e0f5e798a584c6c82ac79d7666911e3.r2.dev/audio/airport_luggage.mp3"},
            {"speaker": "Staff", "es": "En la cinta número 5.", "translation": loc("On belt number 5.", "在 5 號轉盤。",), "audio_ref": "https://pub-8e0f5e798a584c6c82ac79d7666911e3.r2.dev/audio/airport_belt5.mp3"}
        ]
    },
    {
        "title": loc("Ordering Tacos", "點塔可餅"),
        "type": "DIALOGUE",
        "kc": "kc_tourism_phrases",
        "content": [
            {"speaker": "Vendor", "es": "¿Con todo, joven?", "translation": loc("With everything, young man?", "帥哥，要加所有配料嗎？"), "audio_ref": "https://pub-8e0f5e798a584c6c82ac79d7666911e3.r2.dev/audio/tacos_con_todo.mp3"},
            {"speaker": "Traveler", "es": "Sin picante, por favor.", "translation": loc("No spicy, please.", "請不要加辣。",), "audio_ref": "https://pub-8e0f5e798a584c6c82ac79d7666911e3.r2.dev/audio/tacos_no_spicy.mp3"}
        ]
    }
]

tourism_lessons_u2 = [
    {
        "title": loc("Airbnb Problem", "Airbnb 住宿問題"),
        "type": "DIALOGUE",
        "kc": "kc_tourism_phrases",
        "content": [
            {"speaker": "Guest", "es": "Hola, el agua caliente no funciona.", "translation": loc("Hi, the hot water isn't working.", "嗨，熱水器壞了。",), "audio_ref": "https://pub-8e0f5e798a584c6c82ac79d7666911e3.r2.dev/audio/airbnb_water.mp3"},
            {"speaker": "Host", "es": "Lo siento, enviaré a alguien ahora.", "translation": loc("Sorry, I'll send someone now.", "抱歉，我馬上派人過去。",), "audio_ref": "https://pub-8e0f5e798a584c6c82ac79d7666911e3.r2.dev/audio/airbnb_fix.mp3"}
        ]
    }
]

# 6. Business (A1/B1)
business_lessons_u1 = [
    {
        "title": loc("Usted vs Tú in Business", "商務中的您與你"),
        "type": "QUIZ",
        "kc": "kc_business_etiquette",
        "content": [
            {
                "question": loc("Which is appropriate for a new client?", "對新客戶應該用哪個稱呼？"),
                "options": [loc("Tú (Informal)", "Tú (非正式)"), loc("Usted (Formal)", "Usted (正式)"), "Vos (Regional)", "Che (Regional)"],
                "correctIndex": 1
            },
            {
                "question": loc("Translate: 'Estimado Señor'", "翻譯：'Estimado Señor'"),
                "options": [loc("Dear Sir", "尊敬的先生"), loc("Hey Mister", "嘿，先生"), "Hi Man", "Good Morning"],
                "correctIndex": 0
            }
        ]
    }
]

business_lessons_u2 = [
    {
        "title": loc("Supplier Negotiation", "供應商談判"),
        "type": "DIALOGUE",
        "kc": "kc_business_etiquette",
        "content": [
            {"speaker": "Manager", "es": "Necesitamos la entrega para el viernes.", "translation": loc("We need delivery by Friday.", "我們週五前需要收貨。",), "audio_ref": "https://pub-8e0f5e798a584c6c82ac79d7666911e3.r2.dev/audio/biz_delivery.mp3"},
            {"speaker": "Supplier", "es": "Es difícil, pero podemos intentarlo.", "translation": loc("It's difficult, but we can try.", "有點難，但我們可以試試。",), "audio_ref": "https://pub-8e0f5e798a584c6c82ac79d7666911e3.r2.dev/audio/biz_try.mp3"}
        ]
    }
]

# 7. Medical & Life (A1/B1)
med_life_lessons_u1 = [
    {
        "title": loc("Pain Assessment", "疼痛評估"),
        "type": "FLASHCARD",
        "kc": "kc_medical_terms",
        "content": [
            {
                "front": "Dolor agudo", 
                "back": loc("Sharp pain", "劇痛/刺痛"),
                "example": loc("I feel a sharp pain here.", "Siento un dolor agudo aquí. (我這裡感到劇痛。)")
            },
            {
                "front": "Dolor sordo", 
                "back": loc("Dull ache", "隱痛/悶痛"),
                "example": loc("It is a constant dull ache.", "Es un dolor sordo constante. (是持續的隱痛。)")
            },
            {
                "front": "Hinchazón", 
                "back": loc("Swelling", "腫脹"),
                "example": loc("There is a lot of swelling.", "Hay mucha hinchazón. (腫得很厲害。)")
            }
        ]
    }
]

med_life_lessons_u2 = [
    {
        "title": loc("Opening a Bank Account", "銀行開戶"),
        "type": "READING",
        "kc": "kc_bureaucracy",
        "content": {
            "text": "\n            Para abrir una cuenta bancaria en España (Cuenta de No Residente), necesita:\n            1. Pasaporte válido.\n            2. Certificado de No Residente (de la Policía).\n            3. Prueba de dirección (empadronamiento o factura).\n            \n            Algunos bancos online (Neobancos) facilitan el proceso con video-identificación.\n            ",
            "questions": [
                {
                    "question": loc("What certificate is needed?", "需要什麼證書？"),
                    "options": ["Birth Certificate", loc("Non-Resident Certificate", "非居民證明"), "Driving License", "Marriage Certificate"],
                    "correctIndex": 1
                },
                {
                    "question": loc("What alternative exists to traditional banks?", "傳統銀行有什麼替代方案？"),
                    "options": ["Cash only", loc("Neobanks (Online)", "網銀 (Neobancos)"), "Crypto", "Barter"],
                    "correctIndex": 1
                }
            ]
        }
    }
]

# 8. General Intermediate (B1/B2)
general_inter_lessons = [
    {
        "title": loc("The Subjunctive Mood", "虛擬語氣"),
        "type": "DRILL",
        "kc": "kc_subjunctive",
        "content": [
            {"base": "Es importante que tú (comer) bien.", "substitution": "comas", "result": loc("Es importante que tú comas bien.", "重要的是你要吃好。")},
            {"base": "Dudo que él (venir).", "substitution": "venga", "result": loc("Dudo que él venga.", "我懷疑他會來。")},
            {"base": "Ojalá que nosotros (ganar).", "substitution": "ganemos", "result": loc("Ojalá que nosotros ganemos.", "希望我們能贏。")}
        ]
    },
    {
        "title": loc("Accent Challenge: Argentina vs Spain", "口音挑戰：阿根廷 vs 西班牙"),
        "type": "DIALOGUE",
        "kc": "kc_accents",
        "content": [
            {"speaker": "Español", "es": "Aquí tienes las llaves del coche.", "translation": loc("Here are the car keys.", "車鑰匙給你。",), "audio_ref": "https://pub-8e0f5e798a584c6c82ac79d7666911e3.r2.dev/audio/accent_spain_keys.mp3"},
            {"speaker": "Argentino", "es": "¡Che! ¿Viste la lluvia ayer?", "translation": loc("Hey! Did you see the rain yesterday?", "欸！你看到昨天的雨了嗎？",), "audio_ref": "https://pub-8e0f5e798a584c6c82ac79d7666911e3.r2.dev/audio/accent_arg_rain.mp3"}
        ]
    }
]

# 9. General Advanced (C1/C2)
general_adv_lessons = [
    {
        "title": loc("Climate Change Report", "氣候變遷報告"),
        "type": "READING",
        "kc": "kc_current_events",
        "content": {
            "text": "\n            EL CAMBIO CLIMÁTICO Y LA ECONOMÍA:\n            Según el último informe del IPCC, los fenómenos meteorológicos extremos están causando disrupciones significativas en la cadena de suministro global.\n            \n            Se estima que el PIB mundial podría contraerse un 18% para 2050 si no se toman medidas drásticas de mitigación. La transición hacia energías renovables ya no es una opción, sino un imperativo económico.\n            ",
            "questions": [
                {
                    "question": loc("Which organization published the report?", "哪個組織發布了這份報告？"),
                    "options": ["ONU", "IPCC", "WHO", "FIFA"],
                    "correctIndex": 1
                },
                {
                    "question": loc("What is the economic consequence mentioned?", "提到了什麼經濟後果？"),
                    "options": [loc("Growth", "成長 18%"), loc("Contraction of 18%", "萎縮 18%"), "Stability", "Zero Inflation"],
                    "correctIndex": 1
                }
            ]
        }
    },
    {
        "title": loc("Debate: AI Ethics", "辯論：AI 倫理"),
        "type": "ROLEPLAY",
        "kc": "kc_current_events",
        "content": {
            "system_prompt": "You are a philosophy professor debating the ethics of Artificial Intelligence. Challenge the user's views on automation and privacy using complex sentence structures and C1 vocabulary.",
            "initial_message": "Considerando el avance exponencial de la IA, ¿cree usted que la privacidad individual es un sacrificio necesario para el progreso tecnológico?"
        }
    }
]

# 10. FSI Unit 1 (Full Simulation)
fsi_unit1_lessons = [
  {
    "title": loc("Basic Sentences", "基本句型"),
    "type": "DIALOGUE",
    "kc": "kc_basic_greetings",
    "content": [
      {"speaker": "A", "es": "Buenos días.", "translation": loc("Good morning.", "早安。",), "audio_ref": "https://pub-8e0f5e798a584c6c82ac79d7666911e3.r2.dev/audio/l1_0_Buenos_días.mp3"},
      {"speaker": "B", "es": "Buenos días, señor.", "translation": loc("Good morning, sir.", "早安，先生。",), "audio_ref": "https://pub-8e0f5e798a584c6c82ac79d7666911e3.r2.dev/audio/l1_1_Buenos_días_señor.mp3"},
      {"speaker": "A", "es": "¿Cómo está usted?", "translation": loc("How are you?", "您好嗎？",), "audio_ref": "https://pub-8e0f5e798a584c6c82ac79d7666911e3.r2.dev/audio/l1_2_Cómo_está_usted.mp3"}
    ]
  },
  {
    "title": loc("Substitution Drill 1.1", "替換練習 1.1"),
    "type": "DRILL",
    "kc": "kc_subject_pronouns",
    "content": [
      {"base": "Yo voy al banco.", "substitution": "al hotel", "result": loc("Yo voy al hotel.", "我去旅館。")},
      {"base": "Yo voy al hotel.", "substitution": "a la tienda", "result": loc("Yo voy a la tienda.", "我去商店。")},
      {"base": "Yo voy a la tienda.", "substitution": "al mercado", "result": loc("Yo voy al mercado.", "我去市場。")}
    ]
  }
]

# 11. UT Austin Simulation (B1/B2)
ut_austin_lessons = [
    {
        "title": loc("Fútbol: La Pasión de Dos Mundos", "足球：兩個世界的熱情"),
        "type": "DIALOGUE",
        "kc": "kc_accents",
        "content": [
            {"speaker": "Mexicano", "es": "¡No manches! ¿Viste el golazo de ayer?", "translation": loc("No way! Did you see that great goal yesterday?", "不會吧！你看到昨天的世界波了嗎？",), "audio_ref": "https://pub-8e0f5e798a584c6c82ac79d7666911e3.r2.dev/audio/mx_golazo.mp3"},
            {"speaker": "Español", "es": "Sí, tío. Fue una pasada. El balón entró por la escuadra.", "translation": loc("Yeah, man. It was amazing. The ball went into the top corner.", "是啊，兄弟。太神了。球直掛死角。",), "audio_ref": "https://pub-8e0f5e798a584c6c82ac79d7666911e3.r2.dev/audio/es_pasada.mp3"},
            {"speaker": "Mexicano", "es": "Acá en México decimos que la colgó del ángulo.", "translation": loc("Here in Mexico we say he hung it from the angle.", "在我們墨西哥這叫掛死角。",), "audio_ref": "https://pub-8e0f5e798a584c6c82ac79d7666911e3.r2.dev/audio/mx_angulo.mp3"}
        ]
    }
]

# 12. FSI Unit 2 (Greetings & Ser)
fsi_unit2_lessons = [
    {
        "title": loc("Dialogue: At the Office", "對話：在辦公室"),
        "type": "DIALOGUE",
        "kc": "kc_basic_greetings",
        "content": [
            {"speaker": "Sr. A", "es": "Buenas tardes, señor.", "translation": loc("Good afternoon, sir.", "午安，先生。",), "audio_ref": "https://pub-8e0f5e798a584c6c82ac79d7666911e3.r2.dev/audio/l2_1_dialogue_0_Buenas_tardes_señor.mp3"},
            {"speaker": "Sr. B", "es": "Buenas tardes. ¿Es usted el señor García?", "translation": loc("Good afternoon. Are you Mr. Garcia?", "午安。您是 Garcia 先生嗎？",), "audio_ref": "https://pub-8e0f5e798a584c6c82ac79d7666911e3.r2.dev/audio/l2_1_dialogue_1_Buenas_tardes_Es_usted_el_seño.mp3"},
            {"speaker": "Sr. A", "es": "Sí, señor. Y usted es el señor Molina, ¿verdad?", "translation": loc("Yes, sir. And you are Mr. Molina, right?", "是的。那您是 Molina 先生，對吧？",), "audio_ref": "https://pub-8e0f5e798a584c6c82ac79d7666911e3.r2.dev/audio/l2_1_dialogue_2_Sí_señor_Y_usted_es_el_señor_M.mp3"},
            {"speaker": "Sr. B", "es": "Sí, señor. Mucho gusto.", "translation": loc("Yes, sir. Nice to meet you.", "是的。很高興認識您。",), "audio_ref": "https://pub-8e0f5e798a584c6c82ac79d7666911e3.r2.dev/audio/l2_1_dialogue_3_Sí_señor_Mucho_gusto.mp3"}
        ]
    },
    {
        "title": loc("Drill: Ser (To be)", "練習：Ser (是)"),
        "type": "DRILL",
        "kc": "kc_subject_pronouns",
        "content": [
            {"base": "Yo soy cubano.", "substitution": "nosotros", "result": loc("Nosotros somos cubanos.", "我們是古巴人。")},
            {"base": "Nosotros somos cubanos.", "substitution": "ellos", "result": loc("Ellos son cubanos.", "他們是古巴人。")},
            {"base": "Ellos son cubanos.", "substitution": "él", "result": loc("Él es cubano.", "他是古巴人。")}
        ]
    },
    {
        "title": loc("Roleplay: Meeting a Stranger", "角色扮演：遇見陌生人"),
        "type": "ROLEPLAY",
        "kc": "kc_basic_greetings",
        "content": {
            "system_prompt": "You are a Spanish speaker meeting a stranger at a party. Be polite but casual. Use phrases like '¿Cómo te llamas?' and 'Mucho gusto'.",
            "initial_message": "¡Hola! Me llamo Carlos. ¿Y tú?"
        }
    }
]

# --- SQL Generation ---

sql_statements = []

# Helper functions
def course_sql(id, slug, title_en, title_zh, desc_en, desc_zh, level, track, thumb, ver):
    t = json_sql(loc(title_en, title_zh))
    d = json_sql(loc(desc_en, desc_zh))
    return f"INSERT OR REPLACE INTO courses (id, slug, title, description, level, track_type, thumbnail_url, version) VALUES ('{id}', '{slug}', '{t}', '{d}', '{level}', '{track}', '{thumb}', {ver});"

def unit_sql(id, course_id, title_en, title_zh, order):
    t = json_sql(loc(title_en, title_zh))
    return f"INSERT OR REPLACE INTO units (id, course_id, title, order_index) VALUES ('{id}', '{course_id}', '{t}', {order});"

def add_lessons(lessons_data, unit_id):
    for i, lesson in enumerate(lessons_data):
        l_id = f"l_{unit_id}_{i+1}"
        # Lesson Title as JSON
        title_data = lesson['title']
        if isinstance(title_data, str):
             title_data = loc(title_data, title_data) # Fallback
        
        title_json = json_sql(title_data)
        json_content = json_sql(lesson["content"])
        
        sql = f"INSERT OR REPLACE INTO lessons (id, unit_id, title, content_type, content_json, kc_id, order_index) VALUES ('{l_id}', '{unit_id}', '{title_json}', '{lesson['type']}', '{json_content}', '{lesson['kc']}', {i+1});"
        sql_statements.append(sql)

# KCs
sql_statements.append("INSERT OR REPLACE INTO knowledge_components (id, name, description) VALUES ('kc_safety_imperatives', 'Safety Imperatives', 'Commands used in construction safety');")
sql_statements.append("INSERT OR REPLACE INTO knowledge_components (id, name, description) VALUES ('kc_legal_vocabulary', 'Legal Vocabulary', 'Courtroom and legal procedure terms');")
sql_statements.append("INSERT OR REPLACE INTO knowledge_components (id, name, description) VALUES ('kc_bureaucracy', 'Administrative Bureaucracy', 'Visa and paperwork terminology');")
sql_statements.append("INSERT OR REPLACE INTO knowledge_components (id, name, description) VALUES ('kc_arch_terms', 'Architectural Terminology', 'Advanced terms for art history and design');")
sql_statements.append("INSERT OR REPLACE INTO knowledge_components (id, name, description) VALUES ('kc_tourism_phrases', 'Tourism Phrases', 'Survival phrases for travel');")
sql_statements.append("INSERT OR REPLACE INTO knowledge_components (id, name, description) VALUES ('kc_business_etiquette', 'Business Etiquette', 'Formal register and negotiation terms');")
sql_statements.append("INSERT OR REPLACE INTO knowledge_components (id, name, description) VALUES ('kc_medical_terms', 'Medical Terminology', 'Symptoms and anatomy');")
sql_statements.append("INSERT OR REPLACE INTO knowledge_components (id, name, description) VALUES ('kc_subjunctive', 'Subjunctive Mood', 'Expressing doubt, desire, and uncertainty');")
sql_statements.append("INSERT OR REPLACE INTO knowledge_components (id, name, description) VALUES ('kc_accents', 'Regional Accents', 'Distinguishing varieties of Spanish');")
sql_statements.append("INSERT OR REPLACE INTO knowledge_components (id, name, description) VALUES ('kc_current_events', 'Current Events', 'News analysis and debate');")
sql_statements.append("INSERT OR REPLACE INTO knowledge_components (id, name, description) VALUES ('kc_pronunciation_vowels', 'Vowel Pronunciation', 'Mastering a, e, i, o, u');")
sql_statements.append("INSERT OR REPLACE INTO knowledge_components (id, name, description) VALUES ('kc_pronunciation_consonants', 'Tricky Consonants', 'Mastering r, rr, ñ, j, g');")
sql_statements.append("INSERT OR REPLACE INTO knowledge_components (id, name, description) VALUES ('kc_stress_rules', 'Stress Rules', 'Understanding tildes and accentuation');")
sql_statements.append("INSERT OR REPLACE INTO knowledge_components (id, name, description) VALUES ('kc_subject_pronouns', 'Subject Pronouns', 'I, You, He, She, We, They');")
sql_statements.append("INSERT OR REPLACE INTO knowledge_components (id, name, description) VALUES ('kc_basic_greetings', 'Basic Greetings', 'Hello, Goodbye, How are you');")

# Courses (Version 9)
sql_statements.append(course_sql('c_const', 'construction-spanish', 'Spanish for Construction', '建築西班牙語', 'OSHA-aligned safety training.', '符合 OSHA 標準的安全培訓。', 'A2', 'SPECIALIZED', 'assets/images/course_construction.png', 9))
sql_statements.append(course_sql('c_legal', 'legal-spanish', 'Legal Spanish 101', '法律西班牙語 101', 'Essential terminology for legal professionals.', '法律專業人士的必備術語。', 'B2', 'SPECIALIZED', 'assets/images/course_legal.png', 9))
sql_statements.append(course_sql('c_nomad', 'digital-nomad', 'Digital Nomad Spain', '西班牙數位遊牧', 'Visa, Housing, and Taxes.', '簽證、住房和稅務。', 'B1', 'SPECIALIZED', 'assets/images/course_nomad.png', 9))
sql_statements.append(course_sql('c_arch', 'spanish-architecture', 'Historia de la Arquitectura', '西班牙建築史', 'Advanced reading on Spanish art history.', '西班牙藝術史的高階閱讀。', 'C1', 'SPECIALIZED', 'assets/images/course_arch.png', 9))
sql_statements.append(course_sql('c_tourism', 'tourism-spanish', 'Spanish for Tourism', '觀光西班牙語', 'Survival skills for travelers.', '旅行者的生存技能。', 'A1', 'SPECIALIZED', 'assets/images/course_tourism.png', 9))
sql_statements.append(course_sql('c_business', 'business-spanish', 'Business Spanish', '商務西班牙語', 'Professional communication and negotiation.', '專業溝通與談判。', 'B1', 'SPECIALIZED', 'assets/images/course_business.png', 9))
sql_statements.append(course_sql('c_med_life', 'medical-life-spanish', 'Medical & Life Spanish', '醫療與生活西班牙語', 'Healthcare and daily administration.', '醫療保健與日常行政。', 'A2', 'SPECIALIZED', 'assets/images/course_medical.png', 9))
sql_statements.append(course_sql('c_gen_inter', 'general-intermediate', 'Spanish Intermediate', '中級西班牙語', 'B1-B2: Subjunctive and Accents.', 'B1-B2：虛擬語氣與口音。', 'B1', 'GENERAL', 'assets/images/course_general_b1.png', 9))
sql_statements.append(course_sql('c_gen_adv', 'general-advanced', 'Spanish Advanced', '高級西班牙語', 'C1-C2: News and Debate.', 'C1-C2：新聞與辯論。', 'C1', 'GENERAL', 'assets/images/course_general_c1.png', 9))
sql_statements.append(course_sql('c1', 'spanish-foundations-1', 'Spanish Foundations I', '西班牙語基礎 I', 'Based on FSI Vol 1. Master the basics of sentence structure and pronunciation.', '基於 FSI 第一冊。掌握句子結構和發音的基礎。', 'A1', 'GENERAL', 'assets/images/course_a1.png', 9))

# Units
sql_statements.append(unit_sql('u_const_1', 'c_const', 'Safety First & OSHA', '安全第一 & OSHA', 1))
sql_statements.append(unit_sql('u_legal_1', 'c_legal', 'Courtroom Basics', '法庭基礎', 1))
sql_statements.append(unit_sql('u_nomad_1', 'c_nomad', 'The Visa Process', '簽證流程', 1))
sql_statements.append(unit_sql('u_arch_1', 'c_arch', 'Estilos Históricos', '歷史風格', 1))
sql_statements.append(unit_sql('u_tour_1', 'c_tourism', 'Survival Basics', '生存基礎', 1))
sql_statements.append(unit_sql('u_tour_2', 'c_tourism', 'Resolving Issues', '解決問題', 2))
sql_statements.append(unit_sql('u_biz_1', 'c_business', 'Office Etiquette', '辦公室禮儀', 1))
sql_statements.append(unit_sql('u_biz_2', 'c_business', 'Negotiation', '談判', 2))
sql_statements.append(unit_sql('u_med_1', 'c_med_life', 'Medical Triage', '醫療分流', 1))
sql_statements.append(unit_sql('u_life_1', 'c_med_life', 'Life Administration', '生活行政', 2))
sql_statements.append(unit_sql('u_gen_inter_1', 'c_gen_inter', 'Grammar & Listening', '文法與聽力', 1))
sql_statements.append(unit_sql('u_gen_adv_1', 'c_gen_adv', 'Current Affairs', '時事', 1))
sql_statements.append(unit_sql('u1', 'c1', 'Unit 1: The Basics', '第一單元：基礎', 1))
sql_statements.append(unit_sql('u0', 'c1', 'Introduction: Pronunciation', '介紹：發音', 0))
sql_statements.append(unit_sql('u2', 'c1', 'Unit 2: Greetings', '第二單元：問候', 2))

# Add Lessons Calls
add_lessons(construction_lessons, 'u_const_1')
add_lessons(legal_lessons, 'u_legal_1')
add_lessons(nomad_lessons, 'u_nomad_1')
add_lessons(arch_lessons, 'u_arch_1')
add_lessons(tourism_lessons_u1, 'u_tour_1')
add_lessons(tourism_lessons_u2, 'u_tour_2')
add_lessons(business_lessons_u1, 'u_biz_1')
add_lessons(business_lessons_u2, 'u_biz_2')
add_lessons(med_life_lessons_u1, 'u_med_1')
add_lessons(med_life_lessons_u2, 'u_life_1')
add_lessons(general_inter_lessons, 'u_gen_inter_1')
add_lessons(general_adv_lessons, 'u_gen_adv_1')
add_lessons(fsi_unit1_lessons, 'u1')
add_lessons(ut_austin_lessons, 'u_gen_inter_1')
add_lessons(intro_lessons, 'u0')
add_lessons(fsi_unit2_lessons, 'u2')

# Output
with open("../backend/scripts/seed_niche_content.sql", "w") as f:
    f.write("\n".join(sql_statements))

print(f"Generated {len(sql_statements)} SQL statements in backend/scripts/seed_niche_content.sql")