import plotly.express as px

base = 100
steps = 10

ratios = [1, 2, 3, 4, 5, 6]

x = []
y = []

for ratio in ratios:
    for step in range(steps):
        shifted = ratio + (step/steps)
        freq = base*ratio*pow(2,step/steps)

        i = 1
        while freq*i < 4200:
            x.append(shifted)
            y.append(freq*i)
            i = i+1

fig = px.scatter(x=x, y=y)

fig.show()
