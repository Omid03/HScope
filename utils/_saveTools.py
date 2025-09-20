from os.path import basename, split, join
from json import dump, load
import scipy.io as sio
import csv


def get_outfile_name(path, ext=None):
    file_name = basename(path)
    outfile_name = file_name.replace('.', '_')
    if ext is not None:
        outfile_name += f'.{ext}'
    return outfile_name

def save_data_as_json_file(data_dict, path) -> bool:
    try:
        outfile_name = get_outfile_name(path, ext='json')
        dir_path, _ = split(path)
        file_path = join(str(dir_path), outfile_name)

        with open(file_path, 'w') as json_file:
            dump(data_dict, json_file, indent=4)

        return True
    except Exception:
        return False
    
def load_data_from_json_file(path):
    with open(path, 'r') as json_file:
        data = load(json_file)
    return data

def save_data_as_mat_file(data_dict, path) -> bool:
    try:
        outfile_name = get_outfile_name(path, ext='mat')
        dir_path, _ = split(path)
        file_path = join(str(dir_path), outfile_name)

        sio.savemat(file_path, data_dict)

        return True
    except Exception:
        return False
    

    
def dict_to_matlab_str(data_dict):
    rtn_str = ''
    for key, arr in data_dict.items():
        rtn_str += key + '= {'
        arr_str = str(arr)
        arr_str = arr_str[1:-1]
        arr_str = arr_str.strip(',')
        arr_str = arr_str.replace('],', '];\n')
        rtn_str += arr_str + '};'
    return rtn_str

def save_data_as_m_file(data_dict, path) -> bool:
    try:
        outfile_name = get_outfile_name(path, ext='m')
        dir_path, _ = split(path)
        file_path = join(str(dir_path), outfile_name)

        content = dict_to_matlab_str(data_dict)
        with open(file_path, 'w+') as file:
            file.write(content)

        return True
    except :
        return False
    
def save_data_as_csv_file(data_dict, path) -> bool:
    
    if not isinstance(data_dict, dict) or not data_dict:
        return False

    keys = list(data_dict.keys())
    first_key = keys[0]

    try:
        inner_count = len(data_dict[first_key])
    except Exception:
        return False

    if inner_count == 0:
        return False

    try:
        n = len(data_dict[first_key][0])
    except Exception:
        return False

    if n == 0:
       return False

    outfile_name = get_outfile_name(path, ext='csv')
    dir_path, _ = split(path)

    if '.' in outfile_name:
        base = outfile_name.rsplit('.', 1)[0]
        ext = 'csv'
    else:
        base = outfile_name
        ext = 'csv'

    header = keys

    for j in range(inner_count):
        rows = []
        for i in range(n):
            row = [data_dict[k][j][i] for k in keys]
            rows.append(row)

        if inner_count == 1:
            fname = outfile_name
        else:
            fname = f"{base}_{j+1}.{ext}"

        file_path = join(str(dir_path), fname)

        try:
            with open(file_path, 'w', newline='', encoding='utf-8') as f:
                writer = csv.writer(f)
                writer.writerow(header)
                writer.writerows(rows)
        except Exception:
            return False

    return True