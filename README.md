# Odin Facebook

The challenge is to create a working facebook clone with the the underlying database and controller structures, but not the realtime notifications (i.e. backend focused).  It's a learning exercise set by [The Odin Project](https://www.theodinproject.com/courses/ruby-on-rails/lessons/final-project?ref=lnav).

I've added somethings on the way.  



#Notes
I haven't done it exactly as I would a production app as I was using it to learn / practise.  For example I think it would have been better to have Post as a wrapper for text and/or images rather than separate Post and Pic classes, but the latter approach let me play around with polymorphic classes for the comments.

#Live Site
The live site can be founnd at [Heroku](https://safe-sierra-89344.herokuapp.com/pics/1/comments).

The facebook functionality probably won't work for you since it is set to sandbox mode (but the code works when I tested it.)
