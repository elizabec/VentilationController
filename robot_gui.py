import tkinter as tk
import subprocess

class RobotGUI(tk.Tk):

    def __init__(self, *args, **kwargs):
        tk.Tk.__init__(self, *args, **kwargs)

        container = tk.Frame(self)
        container.pack(side="top", fill="both", expand=True)
        container.grid_rowconfigure(0, weight=1)
        container.grid_columnconfigure(0, weight=1)

        self.frames = {}

        for F in (StartPage, USBSelect, MQTTSelect, USBAutoSelect, USBManSelect, MQTTAutoSelect, MQTTManSelect):
            frame_name = F.__name__
            frame = F(parent=container, controller=self)
            self.frames[frame_name] = frame

            frame.grid(row=0, column=0, sticky="nsew")

        self.show_frame("StartPage")

    def show_frame(self, page_name):
        frame = self.frames[page_name]
        frame.tkraise()

    def run_robot_read(self, control):
        if control == "USB":
            subprocess.run(["robot", "-i", "read", "vent_tests_USB.robot"])
        elif control == "MQTT":
            subprocess.run(["robot", "-i", "read", "vent_tests_MQTT.robot"])

    def run_robot_write(self, control, mode):
        if control == "USB":
            if mode == "auto":
                subprocess.run(["robot", "-i", "pressure", "vent_tests_USB.robot"])
            elif mode == "manual":
                subprocess.run(["robot", "-i", "speed", "vent_tests_USB.robot"])
        elif control == "MQTT":
            if mode == "auto":
                subprocess.run(["robot", "-i", "pressure", "vent_tests_MQTT.robot"])
            elif mode == "manual":
                subprocess.run(["robot", "-i", "speed", "vent_tests_MQTT.robot"])

    def run_robot_nodip(self, control, mode):
        if control == "USB":
            if mode == "auto":
                subprocess.run(["robot", "-i", "nodip", "-e", "manual", "vent_tests_USB.robot"])
            elif mode == "manual":
                subprocess.run(["robot", "-i", "nodip", "-e", "automatic", "vent_tests_USB.robot"])
        elif control == "MQTT":
            if mode == "auto":
                subprocess.run(["robot", "-i", "nodip", "-e", "manual", "vent_tests_MQTT.robot"])
            elif mode == "manual":
                subprocess.run(["robot", "-i", "nodip", "-e", "automatic", "vent_tests_MQTT.robot"])

    def run_robot_dip1(self, control, mode):
        if control == "USB":
            if mode == "auto":
                subprocess.run(["robot", "-i", "dipone", "-e", "manual", "vent_tests_USB.robot"])
            elif mode == "manual":
                subprocess.run(["robot", "-i", "dipone", "-e", "automatic", "vent_tests_USB.robot"])
        elif control == "MQTT":
            if mode == "auto":
                subprocess.run(["robot", "-i", "dipone", "-e", "manual", "vent_tests_MQTT.robot"])
            elif mode == "manual":
                subprocess.run(["robot", "-i", "dipone", "-e", "automatic", "vent_tests_MQTT.robot"])

    def run_robot_dip2(self, control, mode):
        if control == "USB":
            if mode == "auto":
                subprocess.run(["robot", "-i", "diptwo", "-e", "manual", "vent_tests_USB.robot"])
            elif mode == "manual":
                subprocess.run(["robot", "-i", "diptwo", "-e", "automatic", "vent_tests_USB.robot"])
        elif control == "MQTT":
            if mode == "auto":
                subprocess.run(["robot", "-i", "diptwo", "-e", "manual", "vent_tests_MQTT.robot"])
            elif mode == "manual":
                subprocess.run(["robot", "-i", "diptwo", "-e", "automatic", "vent_tests_MQTT.robot"])

    def run_robot_bothdip(self, control, mode):
        if control == "USB":
            if mode == "auto":
                subprocess.run(["robot", "-i", "bothdip", "-e", "manual", "vent_tests_USB.robot"])
            elif mode == "manual":
                subprocess.run(["robot", "-i", "bothdip", "-e", "automatic", "vent_tests_USB.robot"])
        elif control == "MQTT":
            if mode == "auto":
                subprocess.run(["robot", "-i", "bothdip", "-e", "manual", "vent_tests_MQTT.robot"])
            elif mode == "manual":
                subprocess.run(["robot", "-i", "bothdip", "-e", "automatic", "vent_tests_MQTT.robot"])

    def run_robot_error(self, control):
        if control == "USB":
            subprocess.run(["robot", "-i", "errorflag", "vent_tests_USB.robot"])
        elif control == "MQTT":
            subprocess.run(["robot", "-i", "errorflag", "vent_tests_MQTT.robot"])

class StartPage(tk.Frame):
    def __init__(self, parent, controller):
        tk.Frame.__init__(self, parent)
        self.controller = controller
        label = tk.Label(self, text="Please choose communication method")
        label.pack(side="top", fill="x")

        button1 = tk.Button(self, text="USB", command=lambda: controller.show_frame("USBSelect"))
        button2 = tk.Button(self, text="MQTT", command=lambda: controller.show_frame("MQTTSelect"))

        button1.pack()
        button2.pack()

class USBSelect(tk.Frame):
    def __init__(self, parent, controller):
        tk.Frame.__init__(self, parent)
        self.controller = controller
        label = tk.Label(self, text="Please choose controller mode")
        label.pack(side="top", fill="x")

        button1 = tk.Button(self, text="Automatic", command=lambda: controller.show_frame("USBAutoSelect"))
        button2 = tk.Button(self, text="Manual", command=lambda: controller.show_frame("USBManSelect"))
        button3 = tk.Button(self, text="Return to Start", command=lambda: controller.show_frame("StartPage"))

        button1.pack()
        button2.pack()
        button3.pack()

class MQTTSelect(tk.Frame):
    def __init__(self, parent, controller):
        tk.Frame.__init__(self, parent)
        self.controller = controller
        label = tk.Label(self, text="Please choose controller mode")
        label.pack(side="top", fill="x")

        button1 = tk.Button(self, text="Automatic", command=lambda: controller.show_frame("MQTTAutoSelect"))
        button2 = tk.Button(self, text="Manual", command=lambda: controller.show_frame("MQTTManSelect"))
        button3 = tk.Button(self, text="Return to Start", command=lambda: controller.show_frame("StartPage"))

        button1.pack()
        button2.pack()
        button3.pack()

class USBAutoSelect(tk.Frame):
    def __init__(self, parent, controller):
        tk.Frame.__init__(self, parent)
        self.controller = controller
        label = tk.Label(self, text="Please choose which test to run")
        label.pack(side="top", fill="x")

        button1 = tk.Button(self, text="Read", command=lambda: controller.run_robot_read("USB"))
        button2 = tk.Button(self, text="Write", command=lambda: controller.run_robot_write("USB", "auto"))
        button3 = tk.Button(self, text="Vents: No Dip Switch", command=lambda: controller.run_robot_nodip("USB", "auto"))
        button4 = tk.Button(self, text="Vents: Dip Switch 1", command=lambda: controller.run_robot_dip1("USB", "auto"))
        button5 = tk.Button(self, text="Vents: Dip Switch 2", command=lambda: controller.run_robot_dip2("USB", "auto"))
        button6 = tk.Button(self, text="Vents: Both Dip Switches", command=lambda: controller.run_robot_bothdip("USB", "auto"))
        button7 = tk.Button(self, text="Return to Start", command=lambda: controller.show_frame("StartPage"))

        button1.pack()
        button2.pack()
        button3.pack()
        button4.pack()
        button5.pack()
        button6.pack()
        button7.pack()

class USBManSelect(tk.Frame):
    def __init__(self, parent, controller):
        tk.Frame.__init__(self, parent)
        self.controller = controller
        label = tk.Label(self, text="Please choose which test to run")
        label.pack(side="top", fill="x")

        button1 = tk.Button(self, text="Read", command=lambda: controller.run_robot_read("USB"))
        button2 = tk.Button(self, text="Write", command=lambda: controller.run_robot_write("USB", "manual"))
        button3 = tk.Button(self, text="Vents: No Dip Switch", command=lambda: controller.run_robot_nodip("USB", "manual"))
        button4 = tk.Button(self, text="Vents: Dip Switch 1", command=lambda: controller.run_robot_dip1("USB", "manual"))
        button5 = tk.Button(self, text="Vents: Dip Switch 2", command=lambda: controller.run_robot_dip2("USB", "manual"))
        button6 = tk.Button(self, text="Vents: Both Dip Switches", command=lambda: controller.run_robot_bothdip("USB", "manual"))
        button7 = tk.Button(self, text="Check Error Flag", command=lambda: controller.run_robot_error("USB", "manual"))
        button8 = tk.Button(self, text="Return to Start", command=lambda: controller.show_frame("StartPage"))

        button1.pack()
        button2.pack()
        button3.pack()
        button4.pack()
        button5.pack()
        button6.pack()
        button7.pack()
        button8.pack()

class MQTTAutoSelect(tk.Frame):
    def __init__(self, parent, controller):
        tk.Frame.__init__(self, parent)
        self.controller = controller
        label = tk.Label(self, text="Please choose which test to run")
        label.pack(side="top", fill="x")

        button1 = tk.Button(self, text="Read", command=lambda: controller.run_robot_read("MQTT"))
        button2 = tk.Button(self, text="Write", command=lambda: controller.run_robot_write("MQTT", "auto"))
        button3 = tk.Button(self, text="Vents: No Dip Switch", command=lambda: controller.run_robot_nodip("MQTT", "auto"))
        button4 = tk.Button(self, text="Vents: Dip Switch 1", command=lambda: controller.run_robot_dip1("MQTT", "auto"))
        button5 = tk.Button(self, text="Vents: Dip Switch 2", command=lambda: controller.run_robot_dip2("MQTT", "auto"))
        button6 = tk.Button(self, text="Vents: Both Dip Switches", command=lambda: controller.run_robot_bothdip("MQTT", "auto"))
        button7 = tk.Button(self, text="Return to Start", command=lambda: controller.show_frame("StartPage"))

        button1.pack()
        button2.pack()
        button3.pack()
        button4.pack()
        button5.pack()
        button6.pack()
        button7.pack()

class MQTTManSelect(tk.Frame):
    def __init__(self, parent, controller):
        tk.Frame.__init__(self, parent)
        self.controller = controller
        label = tk.Label(self, text="Please choose which test to run")
        label.pack(side="top", fill="x")

        button1 = tk.Button(self, text="Read", command=lambda: controller.run_robot_read("MQTT"))
        button2 = tk.Button(self, text="Write", command=lambda: controller.run_robot_write("MQTT", "manual"))
        button3 = tk.Button(self, text="Vents: No Dip Switch", command=lambda: controller.run_robot_nodip("MQTT", "manual"))
        button4 = tk.Button(self, text="Vents: Dip Switch 1", command=lambda: controller.run_robot_dip1("MQTT", "manual"))
        button5 = tk.Button(self, text="Vents: Dip Switch 2", command=lambda: controller.run_robot_dip2("MQTT", "manual"))
        button6 = tk.Button(self, text="Vents: Both Dip Switches", command=lambda: controller.run_robot_bothdip("MQTT", "manual"))
        button7 = tk.Button(self, text="Check Error Flag", command=lambda: controller.run_robot_error("MQTT", "manual"))
        button8 = tk.Button(self, text="Return to Start", command=lambda: controller.show_frame("StartPage"))

        button1.pack()
        button2.pack()
        button3.pack()
        button4.pack()
        button5.pack()
        button6.pack()
        button7.pack()
        button8.pack()


if __name__ == "__main__":
    app = RobotGUI()
    app.mainloop()