import plotly.express as px
import math


def f_half_circle(x):
    return (1-x**2)**(1/2)

delta = 1/100
steps = 600

half_circle = []
f = []
x_c = 0
x_f = []
while x_c <= 1:
    half_circle.append(f_half_circle(x_c))
    f.append(0)
    x_c += delta
    x_f.append(x_c)

samples = len(half_circle)
x = []
for step in range(steps):
    int = 0
    for i in range(samples-1):
        int += delta*min(f[i+step+1], half_circle[i])
    value = 1-math.cos(delta*(step+1))
    f_val = (value - int)/delta
    if f_val < 0:
        f.append(0)
    else:
        f.append(f_val)
    x_f.append(x_f[-1]+delta)

fig = px.scatter(x=x_f, y=f)

fig.show()
