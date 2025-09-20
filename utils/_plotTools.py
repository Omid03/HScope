import numpy as np
import matplotlib
if matplotlib.get_backend() != 'QtAgg':
    matplotlib.use('QtAgg')
import matplotlib.pyplot as plt

def plot_wave_hold_on(x, y, signal_name_y):
    x = np.array(x, dtype=float)
    for y_values in y:
        y = np.array(y_values, dtype=float)
        plt.plot(x, y, label=f"{signal_name_y}")
    
def plot_wave_hold_off(x, y, i, len, signal_name_y):
    x = np.array(x, dtype=float)
    for y_values in y:
        y = np.array(y_values, dtype=float)
        ax = plt.subplot(len, 1, (i - 1) % len + 1)
        ax.plot(x, y)
        try:
            ymin, ymax = y.min(), y.max()
            ax.set_ylim(ymin - 0.02*ymin, ymax + 0.02*ymax)
        except:
            pass
        try:
            xmin, xmax = x.min(), x.max()
            ax.set_xlim((x.min() - x.min() * 1e-9,  x.max() + x.max() * 1e-9))
        except:
            pass 
        ax.axhline(0, linestyle='--', color='gray')
        ax.axvline(0, linestyle='--', color='gray')
        ax.set_ylabel(f"{signal_name_y}")