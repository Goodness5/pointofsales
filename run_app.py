import os
import threading
import subprocess
import webview

def run_django():
    os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'pointofsales.settings')
    subprocess.call(['python', 'manage.py', 'runserver'])

if __name__ == '__main__':
    # Start Django server in a separate thread
    django_thread = threading.Thread(target=run_django)
    django_thread.daemon = True
    django_thread.start()

    # Set the backend using environment variables (Qt or GTK)
    os.environ["WEBVIEW_BACKEND"] = "qt"  # Use "gtk" for GTK backend

    # Create a webview window to display the Django app
    webview.create_window('My Desktop App', 'http://127.0.0.1:8000')

    # Run the main loop of the webview
    webview.start()
