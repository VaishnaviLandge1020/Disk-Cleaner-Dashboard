from flask import Flask, render_template
import shutil

app = Flask(__name__)

def get_disk_usage():
    total, used, free = shutil.disk_usage("/")
    total_gb = total / (1024 ** 3)
    used_gb = used / (1024 ** 3)
    free_gb = free / (1024 ** 3)
    usage_percent = used / total * 100
    return {
        "total": f"{total_gb:.1f} GB",
        "used": f"{used_gb:.1f} GB",
        "free": f"{free_gb:.1f} GB",
        "usage_percent": usage_percent
    }

@app.route("/")
def index():
    disk = get_disk_usage()
    return render_template("index.html", disk=disk)

if __name__ == "__main__":
    app.run(debug=True)

