版本： 2.0 (Final Integrated)

日期： 2025-06-01

目標： 構建全球首個基於「邊緣運算架構」、覆蓋「全能力分級（A1-C2）」與「垂直專業領域」的西班牙語適性化學習生態系。

---

## 1. 執行摘要 (Executive Summary)

本專案旨在解決語言學習市場的「中級斷層」與「通用性疲勞」問題。我們將構建一個雙軌制的學習平台：

1. **通用軌道 (General Track)：** 基於 **FSI (Foreign Service Institute)** 與 **UT Austin** 的公共資源，提供從零基礎到流利的標準化路徑。

2. **專業軌道 (Specialized Track)：** 針對 **建築、醫療、法律、數位遊牧** 等高價值垂直領域，提供基於 **OSHA、EUR-Lex** 等權威文本的實戰訓練。

技術上，本平台將徹底摒棄傳統的單體伺服器架構，全面採用 **Cloudflare Workers (Serverless)** 以實現全球毫秒級響應與極致成本效益；前端採用 **Flutter** 構建全平台應用（iOS, Android, Windows, macOS），並針對桌面端進行深度優化。

---

## 2. 雙軌制課程體系與內容策略 (Curriculum & Content Strategy)

### 2.1 軌道一：通用能力核心 (The General Proficiency Track)

_目標：依據 CEFR 標準，建立從 A1 到 C2 的堅實語言基礎。_

|**分級**|**教學目標**|**核心內容來源 (OER/Public Domain)**|**處理策略**|
|---|---|---|---|
|**A1-A2** (基礎)|生存與機械反應|**FSI Spanish Basic Course (Vol 1)**|**結構化重構：** 將 FSI 的枯燥 PDF 轉化為互動式「替換練習 (Substitution Drills)」。<br><br> <br><br>**音訊切片：** 將長錄音切分為單句，存入 R2，供點讀與跟讀使用。|
|**B1-B2** (中級)|情境溝通與語法深化|**FSI Vol 2-3** + **UT Austin Proficiency Exercises**|**多媒體增強：** 引入 UT Austin 的真實語料視頻，訓練不同口音聽力。<br><br> <br><br>**適性化語法：** 使用 BKT 演算法追蹤「虛擬式 (Subjunctive)」等難點的掌握度。|
|**C1-C2** (高級)|複雜表達與文化深潛|**FSI Vol 4** + **RTVE/BBC Mundo (News API)**|**實時新聞：** 串接新聞 API，自動生成 C1 等級的閱讀測驗。<br><br> <br><br>**長篇敘事：** 利用 AI 生成針對時事的深度討論題。|

### 2.2 軌道二：專業用途西班牙語 (ESP - Specialized Track)

_目標：解決特定職業場景的剛性需求。當用戶達到 B1 水平後解鎖。_

|**利基領域**|**目標客群**|**核心內容來源**|**關鍵功能設計**|
|---|---|---|---|
|**建築與安全** (Construction)|工頭、建築工人|**OSHA 官方西語教材** (Fall Protection, Silica Dust)|**指令聽辨：** 播放 "Amárrese el arnés" (繫好安全帶)，限時點擊對應圖片。<br><br> <br><br>**現場回報：** 模擬向 AI 工頭報告違規狀況。|
|**醫療護理** (Medical)|護士、急救人員|**CDC 西語資源**、**MedlinePlus**|**問診模擬：** 與 AI 病患進行「疼痛評估」對話。<br><br> <br><br>**詞彙庫：** 解剖學術語與症狀描述的閃卡系統。|
|**法律行政** (Legal)|律師、移民顧問|**EUR-Lex** (歐盟法規)、**美國法院詞彙表**|**平行閱讀：** 雙欄顯示英西法律文本，高亮術語差異。<br><br> <br><br>**精準翻譯：** 練習 "Arraignment" (提審) 等術語的精確對譯。|
|**數位遊牧** (Digital Nomad)|遠端工作者|**西班牙簽證官網**、**Peace Corps 手冊**|**行政通關：** 模擬「簽證面試」與「租房合約談判」。<br><br> <br><br>**生活融入：** 銀行開戶與辦理居留證的流程教學。|

---

## 3. 技術架構與規格 (Technical Specifications)

為了支撐上述內容並確保低成本運營，我們採用 **Edge-Native** 架構。

### 3.1 後端基礎設施 (Cloudflare Ecosystem)

- **API Gateway & Compute:**

	- **Cloudflare Workers:** 運行 API 邏輯。使用 **Hono** 框架（輕量、TypeScript 支援）構建 REST API。

	- **優勢：** 冷啟動 < 5ms，全球分發，無伺服器維護成本。

- **資料庫 (Database):**

	- **Content DB (D1):** 存儲課程、詞彙、題目。開啟 **Read Replication** 以加速全球讀取。

	- **User DB (D1):** 存儲用戶進度、BKT 模型參數。

	- **寫入緩衝 (Queues):** 由於 D1 寫入並發限制，所有「學習進度」先推送到 **Cloudflare Queues**，再由 Consumer Worker 批量寫入資料庫。

- **媒體存儲 (Storage):**

	- **Cloudflare R2:** 存儲 FSI 切片音訊、用戶錄音。**零出口費 (Zero Egress Fee)** 是控制頻寬成本的關鍵。

- **AI 推論 (Inference):**

	- **Workers AI:**

		- **Whisper (ASR):** 用於語音轉文字與發音評測。

		- **Llama 3 (LLM):** 用於角色扮演對話與語法糾錯。

### 3.2 前端應用程式 (Flutter Client)

- **框架：** **Flutter** (Dart)。單一代碼庫覆蓋 Mobile (iOS/Android) 與 Desktop (Windows/macOS)。

- **架構模式：** **Clean Architecture** (Data, Domain, Presentation 分層)。

- **狀態管理：** **Riverpod 2.0** (處理異步數據流與依賴注入)。

- **本地資料庫：** **Drift (SQLite)** 或 **Hive**。實現「離線優先」，用戶下載課程包後，無網路亦可學習，聯網後自動同步。

- **桌面端優化 (Desktop Polish):**

	- 使用 `window_manager` 自定義視窗標題列與尺寸約束。

	- 使用 `Shortcuts` widget 實作鍵盤快捷鍵（如 `Space` 播放/暫停，`→` 下一題）。

	- **自適應佈局：** 手機端單欄，桌面端三欄（導航 - 內容 - 筆記/AI 助手）。

---

## 4. 產品功能詳解 (Functional Requirements)

### 4.1 核心學習引擎

- **FR-01 貝氏知識追蹤 (BKT):**

	- 系統不依賴簡單的 SRS，而是計算每個知識點 (KC) 的掌握機率 $P(L_t)$。

	- _實作：_ 輕量級 BKT 算法用 TypeScript 寫在 Worker 中，實時計算用戶答題後的掌握度變化。

- **FR-02 語音評測實驗室:**

	- **跟讀 (Shadowing):** 用戶跟讀 FSI 音訊 -> 上傳 R2 -> 觸發 Whisper 轉錄 -> Worker 比對文本計算「音素級準確度」與「語速」。

	- **視覺反饋：** 前端繪製波形圖，用紅/綠色塊標記發音錯誤的單詞。

### 4.2 內容管理與攝取

- **FR-03 內容管線 (Content Pipeline):**

	- _Local Python Script:_ 開發一組 Python 腳本（不在 Worker 上運行），用於解析原始 PDF/HTML 資源，調用 ffmpeg 切割音訊，生成標準 JSON 格式，並上傳至 D1/R2。

---

## 5. 專案執行任務清單 (Work Breakdown Structure)

### 第一階段：基礎建設與 MVP (Month 1-3)

- **目標：** 完成核心架構搭建，上線「A1 通用西語」與「建築安全」兩個模組。

|**領域**|**任務描述**|**負責人**|
|---|---|---|
|**Backend**|初始化 Cloudflare Workers + Hono 專案結構。|Tech Lead|
|**Backend**|設計 D1 資料庫 Schema (Users, Courses, Progress)。|Tech Lead|
|**Backend**|設置 R2 Bucket 與預簽名 URL (Presigned URL) 邏輯。|Backend Dev|
|**Frontend**|搭建 Flutter 專案與 Clean Architecture 目錄結構。|Frontend Dev|
|**Frontend**|實作基礎 UI 元件 (AudioPlayer, Flashcard, QuizLayout)。|Frontend Dev|
|**Content**|編寫 Python 腳本解析 FSI Vol 1 PDF，提取前 5 單元。|Content Eng|
|**Content**|整理 OSHA 建築安全海報內容，製作成圖文題。|Content Eng|

### 第二階段：語音互動與 BKT 引擎 (Month 4-6)

- **目標：** 實作「聽」與「說」的 AI 功能，並引入適性化算法。

|**領域**|**任務描述**|**負責人**|
|---|---|---|
|**AI**|在 Worker 中整合 Workers AI (Whisper)，實作語音評分邏輯。|Tech Lead|
|**AI**|整合 Llama 3，設計「角色扮演」的 System Prompt。|Tech Lead|
|**Frontend**|實作錄音功能與波形圖視覺化 (Visualizer)。|Frontend Dev|
|**Backend**|實作 BKT 數學模型，並串接 Cloudflare Queues 進行異步寫入。|Backend Dev|
|**Platform**|實作 Flutter 的離線同步機制 (Drift <-> D1 Sync)。|Frontend Dev|

### 第三階段：多利基擴展與桌面優化 (Month 7-9)

- **目標：** 引入法律、運動內容，完善桌面端體驗與付費功能。

|**領域**|**任務描述**|**負責人**|
|---|---|---|
|**Content**|匯入 EUR-Lex 法律雙語文本與 SoccerNet 評論音訊。|Content Eng|
|**Frontend**|針對 Windows/macOS 實作鍵盤快捷鍵與多視窗支援。|Frontend Dev|
|**Frontend**|實作自適應佈局 (Responsive Layout) 以適應大螢幕。|Frontend Dev|
|**Business**|整合 Stripe (Web) 與 RevenueCat (Mobile) 支付。|Backend Dev|
|**Business**|實作「付費牆」與 B2B 企業儀表板 (員工進度查詢)。|Backend Dev|

---

## 6. 資源需求與預算 (Resources & Budget)

### 6.1 人力配置

- **1x Tech Lead / Full Stack:** 精通 TypeScript (Workers) 與 Dart (Flutter)，負責架構與 AI 整合。

- **1x Frontend Developer:** 專注於 Flutter UI/UX、動畫與多端適配。

- **0.5x Content Engineer:** 熟悉 Python 與 NLP，負責資料清洗與轉換腳本。

### 6.2 基礎設施預算 (月估 - 基於 10k 活躍用戶)

|**服務項目**|**規格/用量**|**預估費用 (USD)**|**備註**|
|---|---|---|---|
|**Cloudflare Workers**|Paid Plan|$5.00|包含 1,000 萬次請求，超額極低。|
|**Workers AI**|Whisper/Llama 推論|~$60.00|依賴用戶語音互動頻率，比 OpenAI API 便宜極多。|
|**Cloudflare R2**|100GB 存儲 + 15TB 流量|~$5.00|**零出口費**是最大優勢 (AWS S3 此項需 >$1000)。|
|**Cloudflare D1**|250 億讀取 / 5000 萬寫入|$5.00|包含在 Paid Plan 額度內，基本上夠用。|
|**Cloudflare Queues**|寫入緩衝|$2.00|處理異步寫入。|
|**總計**||**~$77.00 / 月**|**極具競爭力的成本結構**|

---

## 7. 結論與下一步

本計畫書已經將**教育學深度**（CEFR/ESP/FSI）與**技術先進性**（Edge/AI/Flutter）完美結合。

**立即行動項目 (Next Steps):**

1. 註冊 Cloudflare 帳號並開通 Workers Paid ($5)。

2. 初始化 Flutter 專案倉庫。

3. 下載 FSI Spanish Basic Vol 1 PDF 與音訊，開始編寫解析腳本。

