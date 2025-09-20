import numpy as np
from itertools import chain


_SUFFIX_EXP = {
    'd': -1, 'c': -2, 'm': -3, 'u': -6, 'n': -9, 'p': -12, 'f': -15, 'a': -18
}

def extract_blocks(filename, start_marker=b'x', end_marker=b'y'):
    blocks = []
    current_lines = []
    inside_block = False

    with open(filename, 'rb') as f:
        for raw in f:
            s = raw.strip()
            if not inside_block and s == start_marker:
                inside_block = True
                current_lines = []
                continue

            if inside_block and s == end_marker:
                blocks.append(current_lines)
                inside_block = False
                continue

            if inside_block:
                current_lines.append(raw.decode('utf-8').strip())
    return blocks    
    
def convert_value(s: str) -> float:
    s = s.strip()
    if not s:
        return np.nan
    last = s[-1]
    if last.isalpha() and last in _SUFFIX_EXP and ('e' not in s and 'E' not in s):
        try:
            base = float(s[:-1])
            return base * (10.0 ** _SUFFIX_EXP[last])
        except ValueError:
            return np.nan
    try:
        return float(s)
    except ValueError:
        return np.nan

def process_blocks_fast(data, stringVal, Contents):
    
    if not stringVal:
        return data 
    
    tokenized = [[ln.split() for ln in block] for block in stringVal]

    n_rows = len(tokenized[0])
    if n_rows == 0:
        return data

    time_col = np.fromiter(
        (convert_value(toks[0]) if toks else np.nan for toks in tokenized[0]),
        dtype=np.float64, count=n_rows
    ).reshape(-1, 1)

    value_mats = []
    for col_tokens in tokenized:
        max_width = max((len(toks) - 1) for toks in col_tokens) if col_tokens else 0
        if max_width <= 0:
            continue
        mat = np.empty((n_rows, max_width), dtype=np.float64)
        for i, toks in enumerate(col_tokens):
            if len(toks) > 1:
                row_vals = [convert_value(x) for x in toks[1:]]
                if len(row_vals) < max_width:
                    row_vals.extend([np.nan] * (max_width - len(row_vals)))
                mat[i, :] = row_vals
            else:
                mat[i, :] = np.nan
        value_mats.append(mat)

    values = np.hstack([time_col] + value_mats).T if value_mats else time_col.T
    
    types2d = [blk[1].split() for blk in Contents if len(blk) > 2]
    names2d = [blk[2].split() for blk in Contents if len(blk) > 2]
    
    types = list(chain.from_iterable(t[1:] for t in types2d)) if types2d else []
    names = list(chain.from_iterable(n for n in names2d)) if names2d else []
    
    first_row_type = types2d[0][0] if types2d and types2d[0] else None
    first_row_type = first_row_type.upper()
    
    type_names = [type_val +"_"+ name_val for type_val, name_val in zip(types, names)]
    type_names = [first_row_type] + type_names
    
    return {key: [val] for key, val in zip(type_names, values.tolist())}

def reformat(sweep_lst):
    rtn_dict = {key: [] for key in sweep_lst[0].keys()}
    for sweep in sweep_lst:
        for key, value in sweep.items():
            rtn_dict[key].append(value)
    return rtn_dict

def signal_file_ascii_read(post2file):
    f = open(post2file)
    l = f.readline()
    nauto = int(l[0:4])
    nprobe = int(l[4:8])
    nsweepparam = int(l[8:12])
    l = f.readline()
    l = f.readline()
    ndataset = int(l.split()[-1])
    l = f.readline()
    while l.find('$&%#') == -1:
        l = l + f.readline()
    l = l.replace('\n', '')
    simparams = l.split()[:-1]
    datatypes = simparams[0:nauto + nprobe]
    varnames = simparams[nauto + nprobe:2 * (nauto + nprobe)]
    paramnames = simparams[2 * (nauto + nprobe):]

    varnames   = [x.partition('(')[0] if x.startswith('x') else x for x in varnames]
    varnames   = [x.replace('(', '_') for x in varnames]
    varnames   = [x.replace('.', '_') for x in varnames]
    varnames   = [x.replace(':', '_') for x in varnames]
    paramnames = [x.replace(':', '_') for x in paramnames]
    paramnames = ['param_' + x for x in paramnames]

    all_sweep_results = []
    l = f.readline().strip()
    while l:
        this_sweep_result = {}
        for name in varnames:
            this_sweep_result[name] = []
        for name in paramnames:
            this_sweep_result[name] = 0

        numbers = []
        fieldwidth = l.find('E') + 4
        while True:
            lastrow = l.find('0.1000000E+31') != -1
            while l:
                numbers.append(float(l[0:fieldwidth]))
                l = l[fieldwidth:]
            if lastrow:
                break
            else:
                l = f.readline().strip()
        numbers = numbers[:-1]
        params = numbers[:nsweepparam]
        for index in range(len(varnames)):
            this_sweep_result[varnames[index]] = numbers[nsweepparam + index::nauto + nprobe]
        this_sweep_result.update(zip(paramnames, [[x] for x in params]))
        all_sweep_results.append(this_sweep_result)
        l = f.readline().strip()

    f.close()
    return reformat(all_sweep_results)
