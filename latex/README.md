# Latex Sever
Currently Flutter/Dart can't support latex, so I used [`mpysys`](https://www.sympy.org/en/index.html) and [`flask`](https://flask.palletsprojects.com/en/3.0.x/) to create my own own latex (text to image) API

## Build
Install packages:
```shell
pip install -r requirements.txt
```

run the server by:
```shell
python3 ./main.py
```

## How to use?
for example server is running in `https://something.com/latex`
```python
url = "https://something.com/latex"
```
just send a POST request into the server with body of:
```json
{
    "latex": r"$$<DATA>$$"
}
```

