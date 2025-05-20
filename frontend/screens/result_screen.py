"""
Controlador de la pantalla de resultados.
Muestra la imagen segmentada y el texto de diagnóstico.
"""
from kivy.properties         import StringProperty
from kivymd.uix.screen       import MDScreen

class ResultScreen(MDScreen):
    """
    image_source: ruta de la imagen segmentada
    result_text : texto que indica catarata o no
    """
    image_source = StringProperty("")
    result_text  = StringProperty("")
