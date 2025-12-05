# Español Pro 🇪🇸

**An Edge-Native, AI-Powered Spanish Learning Ecosystem.**

Español Pro helps learners break through the "intermediate plateau" with a dual-track system: standard fluency paths and specialized professional training (Medical, Construction, Legal). Built on **Cloudflare's Global Edge** and **Flutter**, it delivers milliseconds latency, offline-first reliability, and advanced AI tutoring features.

---

## 🚀 Key Features

### 📚 Dual-Track Curriculum
*   **General Track:** Based on FSI (Foreign Service Institute) standards for systematic proficiency.
*   **Specialized Track:** Vertical modules for professionals (e.g., "Spanish for Construction Safety").

### 🤖 Advanced AI Tutoring
*   **Speech Evaluation:** Record your voice and get instant pronunciation feedback powered by **OpenAI Whisper** (running on Workers AI).
*   **AI Roleplay:** Chat with "Carlos", an AI tutor powered by **Llama 3**. Practice real-world scenarios with **Real-time Grammar Correction**.

### ⚡ Edge-Native Architecture
*   **Global Low Latency:** Backend logic runs on Cloudflare Workers, distributed close to users worldwide.
*   **Offline-First:** Complete offline support using **Drift (SQLite)**. Progress syncs automatically when back online via a request queue.
*   **Zero-Egress Audio:** High-quality audio assets hosted on **Cloudflare R2**.

### 📱 Cross-Platform
*   **Flutter:** Single codebase for iOS, Android, macOS, and Windows.
*   **Desktop Optimized:** Keyboard shortcuts, adaptive layouts, and window management.

---

## 🛠️ Tech Stack

### Frontend (Client)
*   **Framework:** Flutter (Dart)
*   **State Management:** Riverpod 2.0
*   **Local DB:** Drift (SQLite)
*   **Networking:** Dio
*   **Routing:** GoRouter

### Backend (Cloudflare)
*   **Runtime:** Cloudflare Workers
*   **Framework:** Hono (TypeScript)
*   **Database:** Cloudflare D1 (SQLite at the Edge)
*   **Object Storage:** Cloudflare R2
*   **AI Inference:** Workers AI (@cf/openai/whisper, @cf/meta/llama-3-8b-instruct)

### Content Pipeline
*   **Language:** Python
*   **Tools:** gTTS (Google Text-to-Speech), pydub (Audio manipulation)

---

## 📂 Project Structure

```
/
├── backend/            # Cloudflare Workers API (Hono) & D1 Schema
├── frontend/           # Flutter Application (Clean Architecture)
├── content_pipeline/   # Python scripts for generating audio/JSON content
└── output/             # Generated assets ready for upload
```

---

## 🏁 Getting Started

### Prerequisites
*   **Flutter SDK** (Latest Stable)
*   **Node.js** (v18+) & `npm`
*   **Python** (3.9+)
*   **Cloudflare Account** (Paid plan recommended for AI features, though Free tier works for basic tests)

### 1. Backend Setup

1.  **Install Wrangler:**
    ```bash
    npm install -g wrangler
    ```
2.  **Login to Cloudflare:**
    ```bash
    wrangler login
    ```
3.  **Setup D1 Database:**
    ```bash
    cd backend
    wrangler d1 create espanol-pro-db
    # Update wrangler.toml with the new database_id
    ```
4.  **Apply Schema & Seed Data:**
    ```bash
    wrangler d1 execute espanol-pro-db --file=schema.sql --remote
    wrangler d1 execute espanol-pro-db --file=scripts/seed_d1.sql --remote
    ```
5.  **Deploy Worker:**
    ```bash
    npm install
    npx wrangler deploy
    ```

### 2. Content Setup (Optional)

If you want to regenerate audio or add new lessons:

1.  **Setup Python Environment:**
    ```bash
    cd content_pipeline
    python3 -m venv venv
    source venv/bin/activate
    pip install -r requirements.txt
    ```
2.  **Generate Audio:**
    ```bash
    python generate_audio.py
    ```
3.  **Upload to R2:**
    *   Create an R2 bucket named `espanol-pro-content`.
    *   Configure `wrangler.toml` with the bucket binding.
    *   Use `rclone` or `upload_audio.py` (requires R2 keys) to sync `output/audio` to the bucket.

### 3. Frontend Setup

1.  **Install Dependencies:**
    ```bash
    cd frontend
    flutter pub get
    ```
2.  **Code Generation (Freezed/Drift):**
    ```bash
    dart run build_runner build --delete-conflicting-outputs
    ```
3.  **Configure API URL:**
    *   Open `lib/src/core/api/api_constants.dart`.
    *   Update `baseUrl` with your deployed Worker URL (e.g., `https://espanol-pro-backend.YOUR_SUBDOMAIN.workers.dev`).
4.  **Run the App:**
    ```bash
    flutter run -d macos  # or android/ios/windows
    ```

---

## 🔮 Future Roadmap

*   **Payments:** Integrate RevenueCat for subscription management.
*   **Content Expansion:** Import EUR-Lex (Legal) and Sports commentary datasets.
*   **Community:** Social leaderboards and peer learning groups.

---

*Built with ❤️ by LienCF*
