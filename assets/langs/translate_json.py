from deep_translator import GoogleTranslator
import json
import os

# Paths
LANGS_FOLDER = "assets/langs/"
ENGLISH_JSON_PATH = os.path.join(LANGS_FOLDER, "en-US.json")

# Load English data dynamically
try:
    with open(ENGLISH_JSON_PATH, "r", encoding="utf-8") as f:
        data = json.load(f)
except FileNotFoundError:
    print("❌ English JSON file not found!")
    exit(1)

# Define target languages and their locale codes
languages = {
    "hi-IN": "hi",  # Hindi
    "fr-FR": "fr",  # French
    "es-ES": "es",  # Spanish
    "de-DE": "de"   # German
}

# Translate and save files
for lang_code, lang in languages.items():
    translator = GoogleTranslator(source="en", target=lang)

    translated_file_path = os.path.join(LANGS_FOLDER, f"{lang_code}.json")

    # Load existing translations if available
    if os.path.exists(translated_file_path):
        with open(translated_file_path, "r", encoding="utf-8") as f:
            translated_data = json.load(f)
    else:
        translated_data = {}

    # Translate missing keys only
    for key, value in data.items():
        if key not in translated_data:
            try:
                translated_data[key] = translator.translate(value)
            except Exception as e:
                print(f"⚠️ Error translating '{key}' to {lang_code}: {e}")
                translated_data[key] = value  # Fallback to English

    # Save the translated data
    with open(translated_file_path, "w", encoding="utf-8") as f:
        json.dump(translated_data, f, indent=2, ensure_ascii=False)

    print(f"✅ Translation for {lang_code} updated successfully!")

print("🎉 All translations completed!")
