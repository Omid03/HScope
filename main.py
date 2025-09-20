import os
import sys
import shutil
import subprocess
from pathlib import Path
from utils._extractTools import *
from utils._saveTools import *
from utils._plotTools import *
from utils._calcTools import *

from PySide6.QtCore import QObject, Slot, Signal, QUrl
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtQuickControls2 import QQuickStyle
from PySide6.QtWidgets import QApplication

import ui

QQuickStyle.setStyle("Material") 

class Backend(QObject):

    errorOccurred = Signal(str)
    infoOccurred  = Signal(str)
    warnOccurred = Signal(str)
    proceedHome  = Signal()
    proceedMain  = Signal("QVariant")
    calcMode = Signal("QVariant")
    
    
    def __init__(self, parent=None):
        super().__init__(parent)
        self.data = {} 
        self.file_dir = None
        
    def _validate_path(self, path_like) -> Path:
        p = Path(str(path_like)).expanduser()
        if not p.exists():
            raise FileNotFoundError(f"{p} Not Found")
        if not os.access(p, os.R_OK):
            raise PermissionError(f"{p} Not Readable")
        return p

    @Slot('QString', 'int')
    def receivePathAndMode(self, selectedPath, number):
        if selectedPath:
            path = os.fspath(str(selectedPath))
            mode = int(number)
        else:
            self.errorOccurred.emit("No file path provided.")
            return
        try:
            self.file_dir = self._validate_path(path)
        except (FileNotFoundError, PermissionError) as e:
            self.errorOccurred.emit(str(e))
            return
        
        
        if mode == 0:
            try:
                ok = self.runHspice(path)
                if not ok:
                    self.errorOccurred.emit("HSPICE run failed.")
            except Exception as e:
                self.errorOccurred.emit(f"Error: {e}")
                
        elif mode == 1:
            try:
                ok = self.extract_data(path)
                if not ok:
                    self.errorOccurred.emit("Not able to extract data from the file.")
                else:
                    self.proceedMain.emit(list(self.data.keys()))
            except Exception as e:
                self.errorOccurred.emit(f"Error: {e}")
                
        elif mode == 2:
            try:
                self.data = load_data_from_json_file(os.fspath(self.file_dir))
                if not self.data:
                    self.errorOccurred.emit("Not able to load data from the JSON file.")
                else:
                    self.proceedMain.emit(list(self.data.keys()))
            except Exception as e:
                self.errorOccurred.emit(f"Error loading JSON: {e}")

    def runHspice(self, file_path_qs) -> bool:
        
        file_path = os.fspath(str(file_path_qs)).strip()
        p = Path(file_path)
        if not p.exists():
            self.errorOccurred.emit(f"Input file not found: {p}")
            return False

        hspice_exe = shutil.which("hspice")
        if not hspice_exe:
            self.errorOccurred.emit(
                "HSPICE not found in current PATH. "
                "Please add it to PATH or set full path (e.g., C:\\Synopsys\\Hspice\\bin\\hspice.exe)."
            )
            return False

        try:
            creationflags = 0
            startupinfo = None
            if os.name == "nt":
                creationflags = subprocess.CREATE_NO_WINDOW 
                startupinfo = subprocess.STARTUPINFO()
                startupinfo.dwFlags |= subprocess.STARTF_USESHOWWINDOW
            output_lisfile = p.with_suffix(".lis")
            result = subprocess.run(
                [hspice_exe, os.fspath(p), "-o", os.fspath(output_lisfile)],
                cwd=os.fspath(p.parent), 
                capture_output=True,
                text=True,
                check=True,
                startupinfo=startupinfo,
                creationflags=creationflags
            )

            self.infoOccurred.emit(f"HSPICE ran successfully.\nBut Check if your HSPICE is active")
            return True

        except FileNotFoundError:
            self.errorOccurred.emit("HSPICE executable not found (FileNotFoundError).")
            return False
        except subprocess.CalledProcessError as e:
            err = e.stderr or ""
            out = e.stdout or ""
            self.errorOccurred.emit(
                f"HSPICE failed (exit code {e.returncode}).\n"
                f"--- STDERR ---\n{err}\n"
                f"--- STDOUT ---\n{out}"
            )
            return False
        except Exception as e:
            self.errorOccurred.emit(f"Unexpected error: {e}")
            return False
    
    def extract_data(self, path: Path) -> bool:
        path = path.encode()
        ext = path.split(b'.')[-1].lower()
        if ext == b'lis':
            try:
                Contents = extract_blocks(path)
            except Exception as e:
                self.errorOccurred.emit(f"Error in extracting lines: {e}")
                return False

            if not Contents:
                return False

            try:
                stringVal = [content[3:] for content in Contents]
                self.data = process_blocks_fast(self.data, stringVal, Contents)
                if not self.data:
                    return False
            except Exception as e:
                self.errorOccurred.emit(f"Error in processing data: {e}")
                return False
            return True
        else:
            try:
                self.data = signal_file_ascii_read(path)
                if not self.data:
                    return False
                return True
            except Exception as e:
                self.errorOccurred.emit(f"Error reading ASCII signal file: {e}")
                return False
            
    @Slot()
    def goCalc(self):
        if not self.data:
            self.errorOccurred.emit("No data to show in calculator.")
            return
        self.calcMode.emit(list(self.data.keys()))
        
    @Slot()
    def backToMain(self):
        self.proceedMain.emit(list(self.data.keys()))
        
    @Slot()
    def backToHome(self):
        self.proceedHome.emit()
        
    @Slot()
    def saveAsJSON(self):
        if self.data is None:
            self.errorOccurred.emit("No data to save.")
            return
        try:
            ok = save_data_as_json_file(self.data, os.fspath(self.file_dir))
            if ok:
                self.infoOccurred.emit("Data saved as JSON successfully.")
            else:
                self.errorOccurred.emit("Failed to save data as JSON.")
        except Exception as e:
            self.errorOccurred.emit(f"Error saving JSON: {e}")
            return
    
    @Slot()
    def saveAsCSV(self):
        if self.data is None:
            self.errorOccurred.emit("No data to save.")
            return
        try:
            ok = save_data_as_csv_file(self.data, os.fspath(self.file_dir))
            if ok:
                self.infoOccurred.emit("Data saved as CSV successfully.")
            else:
                self.errorOccurred.emit("Failed to save data as CSV.")
        except Exception as e:
            self.errorOccurred.emit(f"Error saving CSV: {e}")
            return
    
    @Slot()
    def saveAsMAT(self):
        if self.data is None:
            self.errorOccurred.emit("No data to save.")
            return
        try:
            ok = save_data_as_mat_file(self.data, os.fspath(self.file_dir))
            if ok:
                self.infoOccurred.emit("Data saved as MAT successfully.")
            else:
                self.errorOccurred.emit("Failed to save data as MAT.")
        except Exception as e:
            self.errorOccurred.emit(f"Error saving MAT: {e}")
            return
    
    @Slot()
    def saveAsM(self):
        if self.data is None:
            self.errorOccurred.emit("No data to save.")
            return
        try:
            ok = save_data_as_m_file(self.data, os.fspath(self.file_dir))
            if ok:
                self.infoOccurred.emit("Data saved as M successfully.")
            else:
                self.errorOccurred.emit("Failed to save data as M.")
        except Exception as e:
            self.errorOccurred.emit(f"Error saving M: {e}")
            return
    
    @Slot(list, "QString", bool)
    def plotSignal(self, selected_y, selected_x, hold_on):
        if not self.data:
            self.errorOccurred.emit("No data to plot!")
            return
        if selected_y == [] or selected_x == "":
            self.errorOccurred.emit("Select signals to plot.")
            return
        try:
            fig = plt.figure(figsize=(10, 8))
            l = len(selected_y)
            for i, sig in enumerate(selected_y):
                if hold_on:
                    plot_wave_hold_on(self.data[selected_x][0], self.data[sig], sig)
                else:
                    plot_wave_hold_off(self.data[selected_x][0], self.data[sig], i, l, sig)
                fig.supxlabel(selected_x)
            if hold_on:
                plt.legend()
            plt.draw()     
            plt.pause(0.001)
        except Exception as e:
            self.errorOccurred.emit(f"Error plotting signal: {e}")
            return
        
    @Slot("QString", "QString")
    def addVariable(self, expression, var_name):
        var_name = var_name.replace(' ', '_')
        var_name = var_name.replace('-', '_')
        var_name = ''.join(char for char in var_name if char.isalnum() or char == '_')

        if not self.data:
            self.errorOccurred.emit("No data to calculate!")
            return
        if not expression or not var_name:
            self.errorOccurred.emit("Expression or variable name is empty.")
            return
        if var_name in self.data:
            self.errorOccurred.emit(f"Variable '{var_name}' already exists.")
            return
        try:
            result = safe_eval(expression, self.data)
            self.data[var_name] = result
            self.infoOccurred.emit(f"Variable '{var_name}' added successfully.")
            self.proceedMain.emit(list(self.data.keys()))
        except Exception as e:
            self.errorOccurred.emit(f"Error adding variable: {e}")
            return
    

def resource_path(relative_path):
    base_path = getattr(sys, '_MEIPASS', os.path.dirname(os.path.abspath(__file__)))
    return os.path.join(base_path, relative_path)

if __name__ == '__main__':

    app = QApplication(sys.argv)
    engine = QQmlApplicationEngine()

    backend = Backend()
    engine.rootContext().setContextProperty("backend", backend)
    
    ui.qInitResources()
    
    qrc_app = "qrc:/ui/App.qml"
    app_url = QUrl(qrc_app)
    
    engine.load(app_url)
    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec())