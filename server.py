import random
import string
import os,os.path
import cherrypy
from hal import set_motor
from hal import sequence

class StringGenerator(object):
    @cherrypy.expose
    def index(self):
        return open(os.path.join('./public/index.html'))
    @cherrypy.expose
    def generate(self, length=8, cocktail='whiskycoca'):
		return sequence()
#return 'Cocktail ',cocktail,' is Coming'
#''.join(random.sample(string.hexdigits, int(length)))

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
    cherrypy.quickstart(StringGenerator(), '/', conf)
