# 🧹 Disk Cleaner with Web Dashboard

A simple yet powerful disk cleaner built with **Bash** for automation and a lightweight **Python + Flask** dashboard for real-time disk usage monitoring.

---

## 🚀 Features

### 🔧 Disk Cleaner Script (Bash)
- **Three Modes of Operation**:
  - `--auto`: Automatically cleans files based on size, age, and usage threshold.
  - `--interactive`: Prompts user input for path, age, size, and dry-run option.
  - `--dry-run`: Simulates file deletion without actually deleting anything.
- **Deletion Logging**: Keeps a `cleanup.log` showing deleted files and timestamps.
- **Custom Thresholds**: Configure max age and file size for deletion.
  
### 🌐 Web Dashboard (Python + Flask)
- **Real-Time Monitoring**: View total, used, and free disk space.
- **Visual Display**: Clean dashboard UI using HTML and CSS.
- **Built with**: `psutil`, `Flask`, `HTML/CSS`

---

## 🛠️ Tech Stack

- **Bash** – Automation & scripting
- **Python 3** – Backend logic
- **Flask** – Lightweight web server
- **psutil** – Disk usage stats
- **HTML/CSS** – Frontend dashboard

---

## 📁 Project Structure


