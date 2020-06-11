#! /usr/bin/python
import os
import cgi,cgitb

cgitb.enable()
form = cgi.FieldStorage()

print('Content-type: text/html')

if 'HTTP_COOKIE' in os.environ.keys():
	cookie_set = os.environ['HTTP_COOKIE']
	cookies = cookie_set.split(';')
	for acookie in cookies:
		if "level" in acookie:
			level = int(acookie.strip()[-1])
		else:
			level = 1
			print('Set-Cookie: level=1')

else:
	level = 1
	print('Set-Cookie: level=1')

if form.getvalue("level") == "NEXT PHASE":
	level += 1
	print('Set-Cookie: level={}'.format(level))

l1='''
<!DOCTYPE html>
<html>
<head>
	<link href='https://fonts.googleapis.com/css?family=Akronim' rel='stylesheet'>
<style>
body, html {
	background-color: black;
}

h1 {
	color: red;
	font-size: 50px;
	font-family: 'Akronim';
  text-align: center;
}
h2 {
  color: white;
}

.fade-in {
  animation: fadeIn ease 2s;
  -webkit-animation: fadeIn ease 2s;
  -moz-animation: fadeIn ease 2s;
  -o-animation: fadeIn ease 2s;
  -ms-animation: fadeIn ease 2s;
}
@keyframes fadeIn {
  0% {
    opacity:0;
  }
  100% {
    opacity: 1;
  }
}

@-moz-keyframes fadeIn {
  0% {
    opacity:0;
  }
  100% {
    opacity:1;
  }
}

@-webkit-keyframes fadeIn {
  0% {
    opacity:0;
  }
  100% {
    opacity:1;
  }
}

@-o-keyframes fadeIn {
  0% {
    opacity:0;
  }
  100% {
    opacity:1;
  }
}

@-ms-keyframes fadeIn {
  0% {
    opacity:0;
  }
  100% {
    opacity:1;
}

</style>

<title>SURVIVE: Incoming Stuy Freshman</title>
<link rel="icon" href="stuylogo.jpg" type="image/jpg">

</head>
<body>

<div class="fade-in">
  <h1> PHASE 1: Homeroom </h1>
  <form method="get" action="freshman.py">
    <br><br><br><br><br>
    <center>
    <input name="level" type="submit" value="NEXT PHASE" />
    </center>
  </form>
</div>


</body>
</html>'''

l2 = '''
<!DOCTYPE html>
<html>
<head>
	<link href='https://fonts.googleapis.com/css?family=Akronim' rel='stylesheet'>
<style>
body, html {
	background-color: black;
}

h1 {
	color: red;
	font-size: 50px;
	font-family: 'Akronim';
  text-align: center;
}
h2 {
  color: white;
}

.fade-in {
  animation: fadeIn ease 2s;
  -webkit-animation: fadeIn ease 2s;
  -moz-animation: fadeIn ease 2s;
  -o-animation: fadeIn ease 2s;
  -ms-animation: fadeIn ease 2s;
}
@keyframes fadeIn {
  0% {
    opacity:0;
  }
  100% {
    opacity: 1;
  }
}

@-moz-keyframes fadeIn {
  0% {
    opacity:0;
  }
  100% {
    opacity:1;
  }
}

@-webkit-keyframes fadeIn {
  0% {
    opacity:0;
  }
  100% {
    opacity:1;
  }
}

@-o-keyframes fadeIn {
  0% {
    opacity:0;
  }
  100% {
    opacity:1;
  }
}

@-ms-keyframes fadeIn {
  0% {
    opacity:0;
  }
  100% {
    opacity:1;
}

</style>

<title>SURVIVE: Incoming Stuy Freshman</title>
<link rel="icon" href="stuylogo.jpg" type="image/jpg">

</head>
<body>

<div class="fade-in">
  <h1> PHASE 2: Lunch </h1>
  <form method="get" action="freshman.py">
    <br><br><br><br><br>
    <center>
    <input name="level" type="submit" value="NEXT PHASE" />
    </center>
  </form>
</div>


</body>
</html>'''

l3 = '''
<!DOCTYPE html>
<html>
<head>
	<link href='https://fonts.googleapis.com/css?family=Akronim' rel='stylesheet'>
<style>
body, html {
	background-color: black;
}

h1 {
	color: red;
	font-size: 50px;
	font-family: 'Akronim';
  text-align: center;
}
h2 {
  color: white;
}

.fade-in {
  animation: fadeIn ease 2s;
  -webkit-animation: fadeIn ease 2s;
  -moz-animation: fadeIn ease 2s;
  -o-animation: fadeIn ease 2s;
  -ms-animation: fadeIn ease 2s;
}
@keyframes fadeIn {
  0% {
    opacity:0;
  }
  100% {
    opacity: 1;
  }
}

@-moz-keyframes fadeIn {
  0% {
    opacity:0;
  }
  100% {
    opacity:1;
  }
}

@-webkit-keyframes fadeIn {
  0% {
    opacity:0;
  }
  100% {
    opacity:1;
  }
}

@-o-keyframes fadeIn {
  0% {
    opacity:0;
  }
  100% {
    opacity:1;
  }
}

@-ms-keyframes fadeIn {
  0% {
    opacity:0;
  }
  100% {
    opacity:1;
}

</style>

<title>SURVIVE: Incoming Stuy Freshman</title>
<link rel="icon" href="stuylogo.jpg" type="image/jpg">

</head>
<body>

<div class="fade-in">
  <h1> PHASE 3: Clubs </h1>
  <form method="get" action="freshman.py">
    <br><br><br><br><br>
    <center>
    <input name="level" type="submit" value="NEXT PHASE" />
    </center>
  </form>
</div>


</body>
</html>'''

l4 = '''
<!DOCTYPE html>
<html>
<head>
	<link href='https://fonts.googleapis.com/css?family=Akronim' rel='stylesheet'>
<style>
body, html {
	background-color: black;
}

h1 {
	color: red;
	font-size: 50px;
	font-family: 'Akronim';
  text-align: center;
}
h2 {
  color: white;
}

.fade-in {
  animation: fadeIn ease 2s;
  -webkit-animation: fadeIn ease 2s;
  -moz-animation: fadeIn ease 2s;
  -o-animation: fadeIn ease 2s;
  -ms-animation: fadeIn ease 2s;
}
@keyframes fadeIn {
  0% {
    opacity:0;
  }
  100% {
    opacity: 1;
  }
}

@-moz-keyframes fadeIn {
  0% {
    opacity:0;
  }
  100% {
    opacity:1;
  }
}

@-webkit-keyframes fadeIn {
  0% {
    opacity:0;
  }
  100% {
    opacity:1;
  }
}

@-o-keyframes fadeIn {
  0% {
    opacity:0;
  }
  100% {
    opacity:1;
  }
}

@-ms-keyframes fadeIn {
  0% {
    opacity:0;
  }
  100% {
    opacity:1;
}

</style>

<title>SURVIVE: Incoming Stuy Freshman</title>
<link rel="icon" href="stuylogo.jpg" type="image/jpg">

</head>
<body>

<div class="fade-in">
  <h1> PHASE 4: Homework </h1>
  <form method="get" action="freshman.py">
    <br><br><br><br><br>
    <center>
    <input name="level" type="submit" value="NEXT PHASE" />
    </center>
  </form>
</div>


</body>
</html>'''

gameover = '''
<!DOCTYPE html>
<html>
<head>
	<link href='https://fonts.googleapis.com/css?family=Akronim' rel='stylesheet'>
<style>
body, html {
	background-color: black;
}

h1 {
	color: red;
	font-size: 50px;
	font-family: 'Akronim';
  text-align: center;
}
h2 {
  color: white;
}

.fade-in {
  animation: fadeIn ease 2s;
  -webkit-animation: fadeIn ease 2s;
  -moz-animation: fadeIn ease 2s;
  -o-animation: fadeIn ease 2s;
  -ms-animation: fadeIn ease 2s;
}
@keyframes fadeIn {
  0% {
    opacity:0;
  }
  100% {
    opacity: 1;
  }
}

@-moz-keyframes fadeIn {
  0% {
    opacity:0;
  }
  100% {
    opacity:1;
  }
}

@-webkit-keyframes fadeIn {
  0% {
    opacity:0;
  }
  100% {
    opacity:1;
  }
}

@-o-keyframes fadeIn {
  0% {
    opacity:0;
  }
  100% {
    opacity:1;
  }
}

@-ms-keyframes fadeIn {
  0% {
    opacity:0;
  }
  100% {
    opacity:1;
}

</style>

<title>SURVIVE: Incoming Stuy Freshman</title>
<link rel="icon" href="stuylogo.jpg" type="image/jpg">

</head>
<body>

<div class="fade-in">
  <h1> YOU SURVIVED </h1>
</div>


</body>
</html>'''

if level == 1:
	print(l1)

if level == 2:
	print(l2)

if level == 3:
	print(l3)

if level == 4:
	print(l4)

if level > 4:
	print(gameover)
