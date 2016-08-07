import random
import string
import os,os.path
import cherrypy
#from hal import set_angle
#from hal import sequence
from glass import choose_cocktail, emergency_stop
import time



class WebPage(object):
    @cherrypy.expose
    def index(self):
        return open(os.path.join('./public/index.html'))
    @cherrypy.expose
    def loading(self):
        return open(os.path.join('./public/loading.html'))
    @cherrypy.expose
    def generate(self, cocktail='whiskycoca'):
        print "In server.py : Asked for :" + cocktail
        choose_cocktail(cocktail)	
	return  self.index()
    @cherrypy.expose
    def stop(self):
        print "In server.py : Emergency STOP"
        emergency_stop()
        return self.index()

if __name__ == '__main__':
    conf = {
        '/': {
            'tools.sessions.on': True,
            'tools.staticdir.root': os.path.abspath(os.getcwd())
        },
        '/static': {
            'tools.staticdir.on': True,
            'tools.staticdir.dir': './public'
        }
    }
    cherrypy.config.update({'server.socket_port': 8090,
                        'server.socket_host':'0.0.0.0',
                        'engine.autoreload_on': False})
    cherrypy.quickstart(WebPage(), '/', conf)
