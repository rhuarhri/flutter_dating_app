import 'package:flutter/material.dart';
import 'package:flutterdatingapp/database_management_code/online_database.dart';
import 'account_screen_widgets.dart';
import '../common_widgets.dart';

class AccountUpdateScreen extends StatelessWidget
{

  /*
  Kim yo-jong
  likes
  politics
  dramas
  I like to my life private as mush as I can, but i guess I should tell you something.
  I am one of the leading members of a political organisation called the workers party of korea,
  and have a degree in computer science. Though I don't like to brag but i have a very famous
  grandfather. He called kim il sung who was instrumental in creation of North Korea.

  Johnny Depp
  acting
  films
  music
  I am actor. I stared in movies such as the pirates of the caribbean and won awards for my roles.
  But I have always been an actor, in fact in the beginning was a member of a rock band called
  six gun method. I later moved to another band called Rock city angels and in order to make some extra
  cash I worked as a telemarketer. All this changed when I met Nicolas Cage who encouraged me to turn to acting.

  matt smith
  acting
  films
  scifi
  football
  Well I was the eleventh doctor in the TV series Doctor Who, and I sure that is were you have seen me.
  But when I was young I really wanted to be a professional footballer and as a result managed play in the youth
  teams of some major football clubs. However, a serious injury and persistence from my teacher
  made me quit football and move to acting.

  Margot robbie
  acting films
  Life was tough growing up and had to work three jobs to help my family survive. But that did not stop
  my passion for acting. At the age of 17 I took a chance an moved to Melbourne to become a professional
  actor. I acted in a few commercials but I got a big break when I got a role on the Australian soap opera
  Neighbours. My acting career has been progressing ever since and starred in movies such as the birds of prey.

  Angus t jones
  religious
  acting
  films

  If you have seen me at all you will have seen me two and a half men. I spent a lot of my childhood on that
  show and as I changed so did the show. However the changes to the show did not feel right and later
  clashed with my religion, which caused me to quit. Now I help out a religious group called the seventh day
  adventists.


  Katie perry
  singing
  music

  My parents set up churches all across the country, so during my child hood I moved around a lot.
  My devout christian parent were knd out strict, but encouraged me to take up singing by giving me
  lessons and sing in church. At the age of 15 I left school to pursue a music career. Unfortunately
  it had a rocky start as my debut album called Katy Hudson sold poorly, but I kept on going. I eventually
  found fame with my breakthrough album One of the boys and got to the top of the charts with I kissed a girl.

  Ben Smith
  rapping
  music


  I come from a rough part of london, the kind of place estate agents call vibrate. I work as a comedian and
  rapper. Started as rapper doing rap battles in london clubs and became fairly successful at it. I later
  became a comedian when a chance encounter with a comedian working for the BBC got me writing jokes and
  later made me a professional comedian.


  amber heard
  acting
  films

  I come from Austin Texas and I grew up riding horses, hunting and fishing and was a devout catholic, so
  I was in a way a stereotypical Texan. I also participated in a number of beauty competitions, yet another
  texan tradition. This lead on to a modeling career and then to acting. I played roles in a verity of movies
  some of which were not critically nor commercially successful, and some roles in the DC extended universe.
  As well as being an actor, I am also a keen activist supporting groups like LGBTQ.

  Joseph Stalin
  politics
  painting
  drama
  poetry

  I came from humble beginnings as the son of a shoe maker. I am fairly smart with a particular skill in
  poetry and painting. But my story real began in my training as a priest. I was one of 600 trainee priest
  I got a reputation as a trouble maker and the fact that I declared myself atheist didn't help. I
  also joined forbidden book clubs preaching pro revolutionary and marxist ideals. For there I continued
  to help activist groups with their protests never though it put me in danger of arrest. After the death
  of my good friend Vladimir Lenin I worked by way up the ranks of the soviet union until I eventually
  was the leader.

  Carrie lam
  politics

  I come from a working class family in Hong Kong. I always aim to help Hong Kong and improve the lives of it's
  citizens. So when I left university I started a career as a civil servant. I have seen Hong Kong change
  over the years, resulting it's reintegration with china. I am no stranger to controversy as I have
  been a driving force behind many unpopular decisions. Some people have called by a Beijing puppet, because
  of them. But I have always done what I believe is right for the people.




   */

  @override
  Widget build(BuildContext context) {
    Function onCompleteAction = () {
      OnlineDatabaseManager manager = OnlineDatabaseManager();

    if (userNameController.text != "" && userAgeController.text != "")
    {

      String name = userNameController.text;
      int age = int.parse(userAgeController.text);

      String error = manager.update(name, age, gender, lookingFor);

      if (error == "")
      {
        //success
        Navigator.pop(context);
      }
      else
      {
        popup("Error", error, context, (){});
      }

    }
    else
    {
      popup("Error", "You must enter a value for name and age", context, (){});
    }

    };

    return Scaffold(
      appBar: AccountScreenWidgets().accountAppBar(context),
      body: AccountScreenWidgets().accountBody(onCompleteAction, context),
    );
  }

}