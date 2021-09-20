import plotly.express as px
import math

base = 100
delta_0 = 2*math.pi * 1.8/360


x = []
y = []
name = []
phi = 0
i = 0
rows = 4

old = None

for row in range(1,rows+1):
    print(row)
    while (phi/(2*math.pi) // row) < 1:
        #x.append(phi/(2*math.pi))
        x.append(360* phi/(2*math.pi))
        delta_phi = delta_0*pow(math.e, phi*0.0748)
        y.append(rows-row+1)
        phi = phi + delta_phi
        i += 1
        name.append(str(i))
    if old:
        x.append(delta_phi/old)
        y.append(row-0.5)
        name.append("ratio")
    old = delta_phi


#fig = px.scatter(x=x, y=y, log_y=True, hover_name=name)
fig = px.scatter_polar(r=y, theta=x, hover_name=name)

fig.show()
