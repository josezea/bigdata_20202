# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""

import pandas as pd
import numpy as np
#import scypy.stats as sp

a = 2
type(a)
a ** 2

a=[2,4,6]

# Python no trabaja de forma vectorizada

#a**2 # Sale error

b=[]
for i in range(3):
    b.append(a[i]**2)

#[expression for item in list]
[x**2 for x in a]

# La función map permite que la función actúe en cada elemento de la lista
def square(n):
    return n * n

#f(x_i)
#map(f, x) <-> (f(x_1), ...f(x_n))
map(square, a)
list(map(square, a))

# En las series de pandas funcionan las funciones definidas para un número
x=pd.Series([2,4,6], index=['primero', 'segundo', 'tercero'])
square(x)
# Las funciones de elementos si funcionan de forma vectorizadas en las series de pandas


# Este función se define para caracteres
def price_range(brand):
    if brand in ['Samsung','Apple']:
        return 'High Price'
    elif brand =='MI':
        return 'Mid Price'
    else:
        return 'Low Price'

# Función diseñada para un string
price_range('Apple')
price_range("uhuh")
price_range("MI")

# Calculo incorrecto
price_range(['Samsung', 'MI', 'MI', 'Nokia' 'Apple'])

list(map(price_range, ['Samsung', 'MI', 'MI', 'Nokia' 'Apple']))


# Arreglos de Nunpy
x = np.array([1,2,3, 4, 5])
x + 4
x.sum()
x.mean()
x.std()
x.std() / x.mean()
np.log10(np.array([100,2,3, 4, 5]))
np.median(x)

def asimetria(x):
    num = ((x - x.mean())**3) / (len(x)-1)   
    denom = (x.std())**3
    return num.mean() / denom

y = np.array([1,2,3, 4, 50])
asimetria(y)
#asimetria(6) # No funcionar

z = pd.Series([1,2,3, 4, 50])
asimetria(z)

# Ambos funcionan pero los métodos de std son diferentes en un arreglo de numpy y en una serie de pandas
y.std() # Método en la varianza (dentro de la raiz) es dividio sobre n
z.std() # Método en la varianza (dentro de la raiz) es dividio sobre n - 1

# Expresiones lambda
e_lambda = lambda x: x**2
e_lambda(z)
type(e_lambda)


# Método apply para una serie de pandas
y=pd.Series(['Samsung', 'MI', 'MI', 'Nokia', 'Apple'])
y.apply(price_range)
#list(map(price_range, y))

'Celular ' + "Nokia"
y.apply(lambda x:'Celular ' + x)


# Un ejemplo más raro con un método
'El celular es {}'.format('Apple')
y.map('El celular es {}'.format)


################### apply ###########################
df = pd.DataFrame({ 'A': [1,2,3,4], 
                   'B': [10,20,30,40],
                   'C': [20,40,60,80]
                  }, 
                  index=['Row 1', 'Row 2', 'Row 3', 'Row 4'])

# Función pesnada para una serie de pandas
def custom_sum(row):
    return row.sum()
pd.Series([3,4,5]).sum()
custom_sum(pd.Series([3,4,5]))

# Suma por columna
df.apply(custom_sum) 
df.apply(custom_sum, axis=0) # Por defecto
df.loc['Row 5'] = df.apply(custom_sum, axis=0)

# Suma por fila
df.apply(custom_sum, axis=1)
df['D'] = df.apply(custom_sum, axis=1)


# Se puede usar la función apply en una serie de pandas
def multiply_by_2(val):
    return val * 2

multiply_by_2(df['C'])

# No se requiere agregar la dimensión
df['C'].apply(multiply_by_2)
df['D'] = df['C'].apply(multiply_by_2)


# Expresiones lambdas:
df['E'] = df.apply(lambda x:x.mean(), axis=1)
df.loc['Row 6'] = df.apply(lambda x:x.mean(), axis=0)


# applymap, se usa elemento a lemento:
df.applymap(np.square)


########### Acerca de expresiones lambda #################
# Las epxresiones lambdas son funciones!!
f1 = lambda a : a + 10
f1(5)
type(f1)

f2 = lambda a, b, c : a + b + c
print(f2(5, 6, 2))











