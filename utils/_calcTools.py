import numpy as np
from asteval import Interpreter

def expr_format(expr):
    new_expr = ''
    for i, part in enumerate(expr.split('`')):
        if i % 2 == 0:
            new_expr += part
        else:
            new_expr += f"np.array(data['{part}'])"
            
    new_expr = new_expr.replace('×', '*')
    new_expr = new_expr.replace('÷', '/')
    return new_expr

def safe_eval(expr, data_dict):
    aeval = Interpreter()
    aeval.symtable['np'] = np
    aeval.symtable['data'] = data_dict
    new_expr = expr_format(expr)

    try:
        result = aeval(new_expr)
        if aeval.error:
            raise ValueError(f"{aeval.error[0].get_error()}")
        return result.tolist()
    except Exception as e:
        raise ValueError(f"Error evaluating expression: {e}")