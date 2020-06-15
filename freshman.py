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

if form.getvalue("level") == "LEVEL 1":
  level = 1
  print('Set-Cookie: level=1')

if form.getvalue("level") == "LEVEL 2":
  level = 2
  print('Set-Cookie: level=2')

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
p {
  color: white;
  font-size: 20px;
  text-align: center;
}
form {
  text-align: center;
}
input {
  background-color: black;
  color: white;
  border: 2px solid red;
  border-radius: 4px
  width: 40em;
  height: 3em;
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
  <h1> PHASE 1: Get to Homeroom </h1>
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
p {
  color: white;
  font-size: 20px;
  text-align: center;
}
form {
  text-align: center;
}
input {
  background-color: black;
  color: white;
  border: 2px solid red;
  border-radius: 4px
  width: 40em;
  height: 3em;
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
  <h1> PHASE 2: Get to Class </h1>
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
p {
  color: white;
  font-size: 20px;
  text-align: center;
}
form {
  text-align: center;
}
input {
  background-color: black;
  color: white;
  border: 2px solid red;
  border-radius: 4px
  width: 40em;
  height: 3em;
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
  <form method="get" action="freshman.py">
    <p> We wanted to do a "Don't Procrastinate" phase, but decided against it because we are not sufficiently competent in that subject. </p>
    <br>
    <p> Click a button to return to a level! </p>
    <input name="level" type="submit" value="LEVEL 1" />
    <input name="level" type="submit" value="LEVEL 2" />
  </form>
    <br><br><br><br><br>
    <p> By Cyrus Cursetjee and Ivan Wei </p>
  <form method="get" action="about.html">
    <input name="about" type="submit" value="ABOUT" />
  </form>
</div>


</body>
</html>'''

class Tree(object):
  def __init__(self):
    self.left = None
    self.right = None
    self.data = None

if level == 1:
  root = Tree()
  root.data = '''
  <p>Here it is.</p>
  <p>Stuyvesant.</p>
  <p>The entrance looks lively and crowded, yet somehow forboding and imposing.</p>
  <form method="get" action="freshman.py">
    <br>
    <input name="root.right" type="submit" value="NEXT" />
  </form>
  '''

  root.right = Tree()
  root.right.data = '''
  <p> You wonder how your first day will go like, and hope that you won\'t do anything humiliating.</p>

  <form method="get" action="freshman.py">
    <br>
    <input name="root.right2" type="submit" value="NEXT" />
  </form>
  '''

  root.right.right = Tree()
  root.right.right.data = '''
  <p> You take a glance at your friends. </p>
  <p> They're arguing about the speed of different pickaxes in minecraft. </p>

  <form method="get" action="freshman.py">
    <br>
    <input name="root.right3" type="submit" value="NEXT" />
  </form>
  '''

  root.right.right.right = Tree()
  root.right.right.right.data = '''
  <p> Together, you enter. </p>
  <p> A woman in security garb is yelling that everyone go straight to homeroom. </p>
  <p> You check your schedule, which says that your homeroom has room number 379. </p>
  <p> The same floor as your friends' homerooms! </p>

  <form method="get" action="freshman.py">
    <br>
    <input name="root.right4" type="submit" value="NEXT" />
  </form>
  '''

  root.right.right.right.right = Tree()
  root.right.right.right.right.data = '''
  <p> The stairs are to your right, and you can see the escalator further on ahead. </p>
  <p> Your friends want to take that newfangled method of transport, but you have your doubts. </p>
  <p> Someone told you something about the Stuy escalators once... you can't remember. </p>
  <form method="get" action="freshman.py">
    <br>
    <input name="root.right5" type="submit" value="Go up stairs alone" />
    <input name="root.right4.left" type="submit" value="Go up escalator with your buddies" />
  </form>
  '''

  #escalator

  root.right.right.right.right.left = Tree()
  root.right.right.right.right.left.data = '''
  <p> You hear some tall people talking about Freshman hunting and laughing.</p>
  <p> Luckily, you're pretty far away, but you're a bit scared now. </p>
  <p> ... </p>
  <p> Good News: It seems as if you have survived the escalators. </p>
  <p> More Good News: You have five minutes before the start bell rings! </p>

  <form method="get" action="freshman.py">
    <br>
    <input name="root.right4.left2" type="submit" value="Go with your friends to sit outside their homerooms" />
    <input name="homeroom" type="submit" value="Go straight to your assigned homeroom (room 379)" />
  </form>
  '''

  root.right.right.right.right.left.left = Tree()
  root.right.right.right.right.left.left.data = '''
  <p> You sit there and chat with them about your new progress in your Fire Emblem ironman run, forgetting the time. </p>
  <p> Suddenly... RIIIIIIINNNNNGGGGG!!! </p>
  <p> You've RUN OUT OF TIME </p>

  <form method="get" action="freshman.py">
    <br>
    <input name="root" type="submit" value="RESTART" />
  </form>
  '''


  #stairs

  root.right.right.right.right.right = Tree()
  root.right.right.right.right.right.data = '''
  <p> You say goodbye to your friends... you're on your own now. </p>
  <p> You think: Wow, this stairwell is confusing. At least I could cheat on the SHSAT. </p>
  <p> Just kidding, you wouldn't do that! ;) </p>
  <p> You wonder which side of the stairwell to take... </p>

  <form method="get" action="freshman.py">
    <br>
    <input name="root.right5.left" type="submit" value="Left side" />
    <input name="homeroom" type="submit" value="Right side" />
  </form>
  '''

  root.right.right.right.right.right.left = Tree()
  root.right.right.right.right.right.left.data = '''
  <p> A bunch of upperclassmen accost you for going up the wrong side.
  <p> You've been PUBLICLY HUMILIATED </p>

  <form method="get" action="freshman.py">
    <br>
    <input name="root" type="submit" value="RESTART" />
  </form>
  '''

  #wrong homeroom
  homeroom = Tree()
  homeroom.data = '''
  <p> You reach your homeroom, and look inside. </p>
  <p> You think: Huh high schoolers are so tall. </p>
  <p> I don't remember being so short. I blame my parents. </p>

  <form method="get" action="freshman.py">
    <br>
    <input name="homeroom.left" type="submit" value="Don't go in" />
    <input name="homeroom.right" type="submit" value="Go in and take a seat" />
  </form>
  '''

  homeroom.right = Tree()
  homeroom.right.data = '''
  <p> You reach your homeroom, and look inside. </p>
  <p> The teacher asks for your name, and you reply, looking around. Your classmates seem strangely familiar with each other... </p>
  <p> The teacher says: Aww sweetie, are you a Freshman? This is a senior homeroom! </p>
  <p> The whole class laughs at you as you walk out in shame. </p>
  <p> You've been PUBLICLY HUMILIATED </p>


  <form method="get" action="freshman.py">
    <br>
    <input name="root" type="submit" value="RESTART" />
  </form>
  '''

  homeroom.left = Tree()
  homeroom.left.data = '''
  <p> Your schedule must be wrong... those are seniors! (you still blame your parents for faulty genes) </p>
  <p> You can either find one of those illegible posters with homeroom room numbers, or you can ask somebody. </p>

  <form method="get" action="freshman.py">
    <br>
    <input name="homeroom.left.left" type="submit" value="Find a poster" />
    <input name="homeroom.left.right" type="submit" value="Ask somebody" />
  </form>
  '''

  homeroom.left.left = Tree()
  homeroom.left.left.data = '''
  <p> You try to search for a poster by yourself, self-consciously brisk-walking around the third floor </p>
  <p> Nevertheless, you bump into a teacher and blame your parents. </p>
  <p> You found one! You start reading... </p>
  <p> Suddenly... REEEEEEEEEEEE </p>
  <p> -oops </p>
  <p> RRIIIIIIIIINNNNNGGGGGGG!!!!!!!!! </p>
  <p> You've RUN OUT OF TIME </p>

  <form method="get" action="freshman.py">
    <br>
    <input name="root" type="submit" value="RESTART" />
  </form>
  '''

  homeroom.left.right = Tree()
  homeroom.left.right.data = '''
  <p> You quickly locate a big sib, who has a piece of paper with the homeroom numbers! </p>
  <p> Your homeroom is actually on the tenth floor, room 1078. </p>
  <p> You go back up the stairs. </p>

  <form method="get" action="freshman.py">
    <br>
    <input name="sixthfloor" type="submit" value="NEXT" />
  </form>
  '''

  sixthfloor = Tree()
  sixthfloor.data = '''
  <p> You reach the sixth floor and, due to outstanding architecture, the stairwell no longer has two branches. </p>
  <p> It's getting packed... You check the time and realize the start bell is about to ring. </p>
  <p> The escalators might be faster. </p>

  <form method="get" action="freshman.py">
    <br>
    <input name="sixthfloor.left" type="submit" value="Take the escalators" />
    <input name="sixthfloor.right" type="submit" value="Stick with the stairs" />
  </form>
  '''

  sixthfloor.left = Tree()
  sixthfloor.left.data = '''
  <p> You take the escalators... uh oh. </p>
  <p> You realize it only takes one pair of juniors to stand there and stall everyone else. </p>
  <p> It seems that they are unfazed by the possibility of being late. </p>

  <form method="get" action="freshman.py">
    <br>
    <input name="sixthfloor.left.left" type="submit" value="NEXT" />
  </form>
  '''

  sixthfloor.left.left = Tree()
  sixthfloor.left.left.data = '''
  <p> Finally, you reach the 8th floor, and run to get past the juniors. </p>
  <p> You take a turn just to see... a wall. </p>
  <p> There is no 8-10 escalator! </p>
  <p> You fall to your knees and cry in a pot of plants. </p>
  <p> RRRRRRRRRIIIIIIIIIIIIIIIINNNGGGGGGGG!!!!!! (that is so fun to type)</p>
  <p> You've RUN OUT OF TIME </p>

  <form method="get" action="freshman.py">
    <br>
    <input name="root" type="submit" value="RESTART" />
  </form>
  '''

  sixthfloor.right = Tree()
  sixthfloor.right.data = '''
  <p> You remember the story about the escalators now... didn't someone get their toe stuck in it or something? </p>
  <p> You continue up the stairs, and luckily congestion starts to clear. </p>
  <p> You dash to your homeroom... </p>
  <form method="get" action="freshman.py">
    <br>
    <input name="sixthfloor.right.right" type="submit" value="NEXT" />
  </form>
  '''

  sixthfloor.right.right = Tree()
  sixthfloor.right.right.data = '''
  <p> You step in to see an annoyed bald man. </p>
  <p> RIIIIIIIINNNNNNNNNNGGGGGGGGG!!! </p>
  <p> Success! You made it to homeroom just in time. </p>

  <form method="get" action="freshman.py">
    <br>
    <input name="level" type="submit" value="NEXT PHASE" />
  </form>
  '''


  branch = root.data

  #root
  if form.getvalue("root.right")=="NEXT":
    branch = root.right.data
  elif form.getvalue("root.right2")=="NEXT":
    branch = root.right.right.data
  elif form.getvalue("root.right3")=="NEXT":
    branch = root.right.right.right.data
  elif form.getvalue("root.right4")=="NEXT":
    branch = root.right.right.right.right.data

  #stairs
  elif form.getvalue("root.right5")=="Go up stairs alone":
    branch = root.right.right.right.right.right.data
  elif form.getvalue("root.right5.left")=="Left side":
    branch = root.right.right.right.right.right.left.data


  #escalator
  elif form.getvalue("root.right4.left")=="Go up escalator with your buddies":
    branch = root.right.right.right.right.left.data
  elif form.getvalue("root.right4.left2")=="Go with your friends to sit outside their homerooms":
    branch = root.right.right.right.right.left.left.data

  #wrong homeroom
  elif form.getvalue("homeroom")=="Go straight to your assigned homeroom (room 379)" or form.getvalue("homeroom")=="Right side":
    branch = homeroom.data
  elif form.getvalue("homeroom.right")=="Go in and take a seat":
    branch = homeroom.right.data
  elif form.getvalue("homeroom.left")=="Don't go in":
    branch = homeroom.left.data
  elif form.getvalue("homeroom.left.left")=="Find a poster":
    branch = homeroom.left.left.data
  elif form.getvalue("homeroom.left.right")=="Ask somebody":
    branch = homeroom.left.right.data

  #sixth floor
  elif form.getvalue("sixthfloor")=="NEXT":
    branch = sixthfloor.data
  elif form.getvalue("sixthfloor.left")=="Take the escalators":
    branch = sixthfloor.left.data
  elif form.getvalue("sixthfloor.right")=="Stick with the stairs":
    branch = sixthfloor.right.data
  elif form.getvalue("sixthfloor.left.left")=="NEXT":
    branch = sixthfloor.left.left.data
  elif form.getvalue("sixthfloor.right.right")=="NEXT":
    branch = sixthfloor.right.right.data

  close = '''
  </div>
  </body>
  </html>'''
  print(l1 + branch + close)

if level == 2:
  #root
  root = Tree()
  root.data = '''
  <p> You walk out of homeroom, having received your schedule. </p>
  <p> Surprisingly, you attend Freshman Composition and Concert Band and Spanish without incident. </p>
  <p> As you leave Spanish, you display your true Freshman colors by shoveling through your bag to find your schedule. </p>
  <p> It\'s not there! </p>
  <p> You take a glance back into the classroom and it doesn\'t appear to be anywhere near your seat. </p>
  <p> You have two choices: </p>
  <p> Check in the band room and risk being late to your next class. </p>
  <p> Take your phone out to check your schedule on Talos and risk getting caught by a bored teacher. </p>


  <form method="get" action="trylevel2.py">
    <br>
    <input name="root.left" type="submit" value="Check the band room" />
    <input name="root.right" type="submit" value="Check Talos" />
  </form>
  '''

  branch = root.data

  #check talos
  root.right = Tree()
  root.right.data = '''
  <p> Why is it taking so long to load? You frantically glance around for teachers.</p>
  <p> ... </p>
  <p> After a minute, it finally loads! You take a quick look at your schedule when- </p>
  <p> A shrill voice calls out, \"Give me that phone!\" </p>
  <p> You glance up to see the most terrifying sight, a teacher in front of you. </p>
  <p> \"But I was checking-\" </p>
  <p> \"No excuses\". </p>
  <p> You end up getting it confiscated on the first day, and still have no clue where to go. </p>
  <p> You got BAMBOOZLED </p>

  <form method="get" action="trylevel2.py">
    <br>
    <input name="root" type="submit" value="RESTART" />
  </form>
  '''

  if form.getvalue("root.right")=="Check Talos":
    branch = root.right.data

  #check the band room
  root.left = Tree()
  root.left.data = '''
  <p> Well, you better hurry soon. </p>
  <p> You dash down the stairs to the bandroom. </p>
  <p> On the second floor, there is a railing you could jump to potentially save time. </p>

  <form method="get" action="trylevel2.py">
    <br>
    <input name="root.left.left" type="submit" value="Jump the railing" />
    <input name="root.left.right" type="submit" value="Keep on running down" />
  </form>
  '''

  if form.getvalue("root.left")=="Check the band room":
    branch = root.left.data

  root.left.left = Tree()
  root.left.left.data = '''
  <p> You swing one leg over the railing, and your success surprises you. </p>
  <p> You attempt to conceal your internal celebrations. </p>
  <p> When you swing the other one over, your crotch gets stuck on the railing, you tip over and fall. </p>
  <p> Guess you celebrated a bit early. </p>
  <p> Can\'t blame this one on our parents! </p>
  <p> You made a stupid decision and FELL </p>

  <form method="get" action="trylevel2.py">
    <br>
    <input name="root" type="submit" value="RESTART" />
  </form>
  '''

  if form.getvalue("root.left.left")=="Jump the railing":
    branch = root.left.left.data

  root.left.right = Tree()
  root.left.right.data = '''
  <p> Both entrances to the first floor staircase are super close together, so you didn't waste too much time. </p>
  <p> You see that the bandroom is mostly empty, except for a few people leaving and others waiting outside. </p>
  <p> There are two doors too the band room, and you remember that you sat by the back. </p>

  <form method="get" action="trylevel2.py">
    <br>
    <input name="root.left.right.left" type="submit" value="Go through the door by the percussions" />
    <input name="root.left.right.right" type="submit" value="Go through the door by the flutes" />
  </form>
  '''

  if form.getvalue("root.left.right")=="Keep on running down":
    branch = root.left.right.data

  root.left.right.left = Tree()
  root.left.right.left.data = '''
  <p> You make quite the dubious decision to enter on the left side. </p>
  <p> You immediately regret it, having to trudge through and dodge plates, bowls, and kitchen utensils. Oh wait- that's a battery. </p>
  <p> In a hurry, you don\'t see the large timpani covering that has been thrown to the floor. </p>
  <p> It slides out underneath you and you fall. </p>
  <p> You made a stupid decision and FELL </p>

  <form method="get" action="trylevel2.py">
    <br>
    <input name="root" type="submit" value="RESTART" />
  </form>
  '''

  if form.getvalue("root.left.right.left")=="Go through the door by the percussions":
    branch = root.left.right.left.data

  root.left.right.right = Tree()
  root.left.right.right.data = '''
  <p> You pass through the chairs on the flute side, and spot a piece of paper on the floor near your stand </p>
  <p> That\'s your schedule!  You pick it up, and pour through the paper. </p>
  <p> Your next class is Global History, on the third floor, room 305. </p>
  <p> Pretty lucky! That\'s not too far from the band room. </p>
  <p> You've still lost a fair amount of time, and you hustle back to the stairs. </p>
  <p> You\'re fairly sure that the stairs are empty. </p>

  <form method="get" action="trylevel2.py">
    <br>
    <input name="root.left.right.right.left" type="submit" value="Take the left staircase" />
    <input name="root.left.right.right.right" type="submit" value="Take the right staircase" />
  </form>
  '''

  if form.getvalue("root.left.right.right")=="Go through the door by the flutes":
    branch = root.left.right.right.data

  root.left.right.right.left = Tree()
  root.left.right.right.left.data = '''
  <p> You end up in the middle of a hallway, and glance up towards the room numbers
  <p> You think: I'm looking for 305, I'm looking for 305, I'm lookin- </p>
  <p> Wait a second. Why are the numbers increasing? </p>
  <p> You start dashing towards the other wing of the floor, but as you are in the middle of the hallway- </p>
  <p> RRIIIIIIIIIIINNNNNGGGGGGGGGGG!!!!!!! </p>
  <p> You've RUN OUT OF TIME </p>

  <form method="get" action="trylevel2.py">
    <br>
    <input name="root" type="submit" value="RESTART" />
  </form>
  '''

  if form.getvalue("root.left.right.right.left")=="Take the left staircase":
    branch = root.left.right.right.left.data

  root.left.right.right.right = Tree()
  root.left.right.right.right.data = '''
  <p> You end up in the middle of the hallway, and Naruto into room 305. </p>
  <p> Your teacher says hi. </p>
  <p> Your teacher promises to curve you to 100 at the end of the semester. </p>
  <p> Your teacher is genuinely happy to be here. </p>
  <p> (Just kidding about the last bits) :P </p>

  <form method="get" action="trylevel2.py">
    <br>
    <input name="level" type="submit" value="NEXT PHASE" />
  </form>
  '''

  if form.getvalue("root.left.right.right.right")=="Take the right staircase":
    branch = root.left.right.right.right.data

  close = '''
  </div>
  </body>
  </html>'''
  print(l2 + branch + close)

if level > 2:
  print(gameover)
