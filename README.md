<p align="left">
  <img src="ui/images/HScope-Icon.png" width=300 alt="Icon">
</p>

# Open-Source GUI for HSPICE Data Analysis & Waveform Visualization

Download Links
---
[Download HScope Setup v1.0.0 for Windows (64-bit)](https://github.com/Omid03/HScope/releases/download/v1.0.0/HScope-Setup-1.0.0.exe)

[Download HScope Portable v1.0.0 for Windows (64-bit)](https://github.com/Omid03/HScope/releases/download/v1.0.0/HScope.exe)

---
**HScope** is an open-source, standalone desktop Graphical User Interface (GUI) application designed for running simulations, automatically and parallelly extracting output data, performing mathematical signal calculations, and visualizing waveforms from **HSPICE** digital and analog circuit simulations.

---

## 📖 Table of Contents
* [Key Features](#-key-features)
* [Project Architecture](#%EF%B8%8F-project-architecture)
* [Getting Started](#%EF%B8%8F-getting-started)
* [Roadmap & Contributing (Call for Collaboration)](#-roadmap--contributing)
* [Acknowledgments & Credits](#-acknowledgments--credits)

---
## 🚀 Key Features

### 1. Three Flexible Input Workflows
* **Run HSPICE Directly (`Run HSPICE`):** Select `.sp` netlist files (`*.sp`) and trigger HSPICE simulations directly from the interface.
* **Automated & Parallel Data Extraction (`Extract Data`):** Parse and extract numerical data and key parameters in parallel from HSPICE output files, supporting `*.lis`, transient (`*.tr*`), DC sweep (`*.sw*`), and AC analysis (`*.ac*`) files.
* **Session Reloading (`Load Data`):** Quickly reload previously extracted simulation datasets from `.json` files (`*.json`) without re-parsing raw HSPICE outputs.

### 2. Built-in Signal Calculator
* **Custom Variable Definition:** Create new analytical variables by combining existing simulation signals using mathematical expressions.
* **Smart Variable Token Insertion:** Includes a searchable signal list that inserts variable names enclosed in backticks (`` `variable` ``) and removes entire variable tokens at once when pressing backspace (`⌫`).
* **Syntax & Naming Validation:** Enforces clean variable naming conventions (unique variable names, standard mathematical syntax, `_` as a word delimiter, and no special characters).

### 3. Multi-Format Data Export
* **Standard Scientific Formats:** Export processed simulation datasets via the sidebar `Save as …` menu directly into **CSV** (`.csv`), **MATLAB Data** (`.mat`), and **MATLAB Script** (`.m`) formats, as well as **Excel** (`.xlsx`).
* **JSON Export:** Save the active dataset as a `.json` file (`Export JSON file`) for fast future reloading inside HScope.

### 4. Frameless UI (`App.qml` & `CustomDialog.qml`)
* **Dark Material Interface:** Built with QtQuick/QML (`Material.Dark` theme), featuring a custom frameless window (`Qt.FramelessWindowHint`), draggable titlebar (`DragHandler`), smooth 280ms cross-fade page transitions (`ParallelAnimation`), and a blurred slide-out navigation drawer (`DesignEffect`).
* **Contextual Modal Dialogs:** Custom color-coded dialog system supporting `error`, `warn`, `info`, and asynchronous `ask` confirmation prompts (`Promise`-based `Yes`/`No` dialogs).

---

## 🛠️ Project Architecture

The repository is structured into modular QML frontend views and Python backend processing utilities:
```
HScope/
├── main.py                 # Main application entry point
├── ui.py                   # Bridge controller connecting QML frontend and Python backend
├── resources.qrc           # Qt resource collection file for icons and UI assets
├── requirements.txt        # Python package dependencies
├── ui/                     # QtQuick / QML user interface components
│   ├── App.qml             # Frameless window container, titlebar, and page transition loader
│   ├── BrowsePage.qml      # Home view (Run .sp, Extract .lis/.tr*/.sw*/.ac*, Load .json)
│   ├── Main.qml            # Axis selection workspace, waveform plotting, and export drawer
│   ├── Calc.qml            # Built-in mathematical calculator for defining new variables
│   ├── CustomDialog.qml    # Modal dialog component for error, warning, info, and ask prompts
│   └── images/             # Application logo (HScope.svg) and SVG UI icons
└── utils/                  # Backend processing modules
    ├── _extractTools.py    # Parallel HSPICE output file parser and data extractor
    ├── _calcTools.py       # Mathematical expression evaluator for custom signals
    ├── _plotTools.py       # Matplotlib waveform plotting utilities
    └── _saveTools.py       # Export handlers (.csv, .mat, .m, .json, .xlsx)
```

## ⚙️ Getting Started

Follow these steps to set up and run HScope on your local machine:

Clone the repository:
```Bash

    git clone https://github.com/Omid03/HScope.git
    cd HScope
```
Install the required Python dependencies:
```Bash
    pip install -r requirements.txt
```
Run the application:
```Bash
    python main.py
```
(Note: The project also supports packaging into a standalone executable installer via tools such as PyInstaller or NSIS.)

## 🤝 Roadmap & Contributing (Call for Collaboration)

HScope is an open-source initiative, and contributions from developers, researchers, and EDA (Electronic Design Automation) enthusiasts are warmly welcomed!
Future Development Plans & Roadmap

- Migration from Python to C/C++: Porting the core backend and application architecture from Python to C/C++ to achieve higher execution speed, lower memory overhead on large simulation files, and native standalone performance.

- Extended Mathematical & Algebraic Operations: Expanding the built-in calculator (Calc.qml and _calcTools.py) to support advanced mathematical, algebraic, differential, and statistical functions.

- Support for Multiple HSPICE Output Standards: Expanding the extraction engine (_extractTools.py) to support a wider variety of HSPICE output formats and versions (currently, only the default output standard of HSPICE 2019 is implemented).

How to Contribute & Request Full Project Code

If you are interested in collaborating, extending these features, or continuing the development of HScope, please reach out via email to receive the complete source code and project documentation:

- Contact Email: omdgzade1380@gmail.com

- GitHub Repository: https://github.com/Omid03/HScope

## 💖 Acknowledgments & Credits

__HSPICE Data Extraction Engine: The HSPICE file extraction module (utils/_extractTools.py) was developed with inspiration and assistance from the open-source HMC-ACE/hspiceParser repository. Specifically, this implementation utilizes the parser standard corresponding to the default output format of HSPICE 2019.__
