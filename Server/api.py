import tornado.escape
import tornado.ioloop
import tornado.web
import json
import os
from google.cloud import language
from google.cloud.language import enums
from google.cloud.language import types
import eva2l
import json

from tornado.options import define, options, parse_command_line

define("port", default=8891, help="run on the given port", type=int)
define("debug", default=False, help="run in debug mode")
TEXT_DIARY = 1
VIDEO_DIARY = 2
client = language.LanguageServiceClient()

class MainHandler(tornado.web.RequestHandler):
	def get(self):
		pass

	def post(self):
		pass

class DiaryHandler(tornado.web.RequestHandler):
	def post(self):
		content = self.get_argument("content", "", True)
		
		document = types.Document(
			content=content,
			type=enums.Document.Type.PLAIN_TEXT)
		annotations = client.analyze_sentiment(document=document)
		
		result = {}
		result['content'] = content
		result['score'] = annotations.document_sentiment.magnitude
		self.finish(result)

class EventHandler(tornado.web.RequestHandler):
	def get(self):
		with open('score', 'r') as f:
			score = float(f.read())
			events = json.load(open('events.json'))
			result = {'score': score, 'events': events}
			self.finish(result)

class UploadHandler(tornado.web.RequestHandler):
	def post(self):
		video_file = self.request.files['video'][0]
		filename = video_file['filename']
		response = {'filename': filename}
		self.finish(response)

def main():
	parse_command_line()
	app = tornado.web.Application(
		[
			(r"/", MainHandler),
			(r"/diary", DiaryHandler),
			(r"/event", EventHandler),
			(r"/upload", UploadHandler),
		],
		cookie_secret="__TODO:_GENERATE_YOUR_OWN_RANDOM_VALUE_HERE__",
		template_path=os.path.join(os.path.dirname(__file__), "templates"),
		static_path=os.path.join(os.path.dirname(__file__), "static"),
		xsrf_cookies=False,
		debug=options.debug,
	)
	app.listen(options.port)
	tornado.ioloop.IOLoop.current().start()


if __name__ == "__main__":
	main()