import tkinter as tk
from tkinter import ttk
import re
import os

def submit():
    nickname = nickname_var.get()
    is_hot = hot_var.get() == 1
    is_cold = hot_var.get() == 2
    morning_time = morning_time_var.get()
    night_time = night_time_var.get()
    print(f"{nickname},{is_hot},{is_cold},{morning_time},{night_time}")
    root.destroy()

def reject():
    root.destroy()
    os._exit(0)  # 全てのプログラムを強制終了

def validate_time(time_str, start_hour, end_hour):
    if not re.match(r'^\d{2}:\d{2}$', time_str):
        return False
    try:
        hour, minute = map(int, time_str.split(":"))
        if start_hour <= hour < end_hour and 0 <= minute < 60:
            return True
        # 特殊なケースとして、夜の時間が26:59まで許容される
        if start_hour == 19 and hour < 27 and 0 <= minute < 60:
            return True
    except ValueError:
        pass
    return False

def validate_input(*args):
    nickname = nickname_var.get()
    is_hot = hot_var.get() == 1
    is_cold = hot_var.get() == 2
    morning_time = morning_time_var.get()
    night_time = night_time_var.get()
    
    is_valid_nickname = re.match(r'^[\u3040-\u30FF\u4E00-\u9FFF]+$', nickname) is not None
    is_valid_morning_time = validate_time(morning_time, 3, 12)
    is_valid_night_time = validate_time(night_time, 19, 27)
    
    if is_valid_nickname and (is_hot or is_cold or hot_var.get() == 0) and is_valid_morning_time and is_valid_night_time:
        submit_button.state(["!disabled"])
    else:
        submit_button.state(["disabled"])

root = tk.Tk()
root.title("Weather Forecast")
root.geometry("1920x1080")
root.configure(bg="white")

root.protocol("WM_DELETE_WINDOW", lambda: None)

# ウィンドウの最小化とタスクバーからの削除を無効にする
root.attributes("-toolwindow", True)

# ウェルカムメッセージ
welcome_label = tk.Label(root, text="ようこそ Weather Forecastへ!\nまずは、アンケート画面を入力してください", bg="white", fg="blue", font=("Helvetica", 16))
welcome_label.pack(pady=20)

# フォームのフレーム
form_frame = tk.Frame(root, bg="white", padx=20, pady=20)
form_frame.place(relx=0.5, rely=0.5, anchor="center")

# ニックネーム入力の説明ラベル
nickname_instruction_label = tk.Label(form_frame, text="ニックネームを日本語で入力してください", bg="white", fg="blue", font=("Helvetica", 12))
nickname_instruction_label.grid(row=0, column=0, columnspan=2, pady=10, sticky="w")

# ラベルとエントリー（ニックネーム）
nickname_label = tk.Label(form_frame, text="ニックネーム", bg="white", fg="blue", font=("Helvetica", 12))
nickname_label.grid(row=1, column=0, pady=10, sticky="e")

nickname_var = tk.StringVar()
nickname_var.trace_add("write", validate_input)
nickname_entry = ttk.Entry(form_frame, font=("Helvetica", 12), textvariable=nickname_var)
nickname_entry.grid(row=1, column=1, pady=10, sticky="w")

# 暑がりか寒がりか入力の説明ラベル
preference_instruction_label = tk.Label(form_frame, text="暑がりか寒がりか入力してください", bg="white", fg="blue", font=("Helvetica", 12))
preference_instruction_label.grid(row=2, column=0, columnspan=2, pady=10, sticky="w")

# ラジオボタン（暑がりか寒がりか）
hot_var = tk.IntVar()
hot_var.trace_add("write", validate_input)

hot_radio = ttk.Radiobutton(form_frame, text="暑がり", variable=hot_var, value=1, style="BW.TRadiobutton")
hot_radio.grid(row=3, column=0, pady=10, sticky="w")

cold_radio = ttk.Radiobutton(form_frame, text="寒がり", variable=hot_var, value=2, style="BW.TRadiobutton")
cold_radio.grid(row=3, column=1, pady=10, sticky="w")

neutral_radio = ttk.Radiobutton(form_frame, text="どちらでもない", variable=hot_var, value=0, style="BW.TRadiobutton")
neutral_radio.grid(row=3, column=2, pady=10, sticky="w")

# 朝の時間入力の説明ラベル
morning_time_instruction_label = tk.Label(form_frame, text="情報を伝える朝の時間(03:00~12:00)を入力してください (例: 08:00)", bg="white", fg="blue", font=("Helvetica", 12))
morning_time_instruction_label.grid(row=4, column=0, columnspan=2, pady=10, sticky="w")

# ラベルとエントリー（朝の時間）
morning_time_label = tk.Label(form_frame, text="朝の時間", bg="white", fg="blue", font=("Helvetica", 12))
morning_time_label.grid(row=5, column=0, pady=10, sticky="e")

morning_time_var = tk.StringVar()
morning_time_var.trace_add("write", validate_input)
morning_time_entry = ttk.Entry(form_frame, font=("Helvetica", 12), textvariable=morning_time_var)
morning_time_entry.grid(row=5, column=1, pady=10, sticky="w")

# 夜の時間入力の説明ラベル
night_time_instruction_label = tk.Label(form_frame, text="情報を伝える夜の時間(19:00~27:00)を入力してください (例: 20:00)", bg="white", fg="blue", font=("Helvetica", 12))
night_time_instruction_label.grid(row=6, column=0, columnspan=2, pady=10, sticky="w")

# ラベルとエントリー（夜の時間）
night_time_label = tk.Label(form_frame, text="夜の時間", bg="white", fg="blue", font=("Helvetica", 12))
night_time_label.grid(row=7, column=0, pady=10, sticky="e")

night_time_var = tk.StringVar()
night_time_var.trace_add("write", validate_input)
night_time_entry = ttk.Entry(form_frame, font=("Helvetica", 12), textvariable=night_time_var)
night_time_entry.grid(row=7, column=1, pady=10, sticky="w")

# 送信ボタン
submit_button = ttk.Button(form_frame, text="送信", command=submit, style="BW.TButton", state="disabled")
submit_button.grid(row=8, column=0, pady=10, sticky="e")

# 入力拒否ボタン
reject_button = ttk.Button(form_frame, text="入力拒否", command=reject, style="BW.TButton")
reject_button.grid(row=8, column=1, pady=10, sticky="w")

# スタイルの設定
style = ttk.Style()
style.configure("BW.TButton", background="white", foreground="blue")
style.configure("BW.TRadiobutton", background="white", foreground="blue")

# メインループ
root.mainloop()