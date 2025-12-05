import os
import subprocess

AUDIO_DIR = 'output/audio'
BUCKET_NAME = 'espanol-pro-content'

def upload_files():
    if not os.path.exists(AUDIO_DIR):
        print(f"Directory not found: {AUDIO_DIR}")
        return

    files = [f for f in os.listdir(AUDIO_DIR) if f.endswith('.mp3')]
    print(f"Found {len(files)} files to upload.")
    
    # Use absolute path to avoid CWD confusion
    abs_audio_dir = os.path.abspath(AUDIO_DIR)

    for filename in files:
        local_path = os.path.join(abs_audio_dir, filename)
        key = filename # Upload to root of bucket
        print(f"Uploading {filename}...")
        
        cmd = [
            "npx", "wrangler", "r2", "object", "put", 
            f"{BUCKET_NAME}/{key}", 
            "--file", local_path
        ]
        
        # Run from backend dir to pick up auth/config if needed (safest)
        try:
            subprocess.run(cmd, cwd="../backend", check=True)
        except subprocess.CalledProcessError as e:
            print(f"Failed to upload {filename}: {e}")

if __name__ == "__main__":
    upload_files()
