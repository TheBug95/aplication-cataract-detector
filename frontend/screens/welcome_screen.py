# frontend/screens/welcome_screen.py
#
#  Controlador de la pantalla de bienvenida.
#  Solo contiene callbacks y lógica mínima.
#
from kivymd.uix.screen import MDScreen
from kivymd.toast      import toast


class WelcomeScreen(MDScreen):

    def on_start_button(self):
        """
        Callback del botón 'Get Started'.
        """
        toast("Get Started pulsed")

        self.manager.current = "choose_photo"
