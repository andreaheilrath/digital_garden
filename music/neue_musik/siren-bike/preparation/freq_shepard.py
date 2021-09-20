import plotly.express as px

base = 100
rel_step = 0.01


x = []
y = []

shift = 1
freq = base
while shift < 4.1:
    i = 1
    while freq*i < 4200:
        x.append(shift)
        y.append(freq*i)
        i = i+1
    shift = shift + rel_step
    freq = base*pow(2,shift-1)

fig = px.scatter(x=x, y=y, labels={"x":"octave","y": "frequency / overtones"})

fig.show()
