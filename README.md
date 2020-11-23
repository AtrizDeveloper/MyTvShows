# MyTvShows!

Hola, mi nombre es Jair Muñoz González, estoy postulandome para el puesto de desarrollador en iOS; tengo formación como Ingeniero Mecatrónico, sin embargo, encontré mi pasión en la programación, particularmente en las aplicaciones moviles, mi recorrido me llevó a dominar JAVA, programo en Android desde el 2012, fue hasta el año pasado que pude comenzar con iOS y la transcición, aunque fue divertida, tuvo sus tropiezos.

## Arquitectura

La selección fue simple, Swift prácticamente te induce a utilizar MVC con aires de poder implementar otro tipo de arquitectura MVVM, en la raíz de la aplicación encontraremos agrupados las controladores, modelos y estructuras, vistas y customs (aquí usualmente agrego widgets que no vienen por default, como los gradientes). Utilizo StoryBoard por comodidad, y porque para el proyecto en cuestión, era más simple de implementar.


## Librerías

 - [Alamofire](https://github.com/Alamofire/Alamofire) - Excelente para manejar peticiones HTTP, completa y fácil de implementar, la elegí porque su implementación de eventos y errores me ahorra muchísimo tiempo de desarrollo.
 - [SwiftyJson](https://github.com/SwiftyJSON/SwiftyJSON) - Lo primero que noté en mi transición de Android a iOS fue el dolor de cabeza que representa manejar JSON en swift, sin embargo, esta librería es **S-o-b-e-r-b-i-a**, facilita su manejo y no hace que quiera estrellar la pantalla.
 - [Kingfisher](https://github.com/onevcat/Kingfisher) - Simplemente es un gestor **maravilloso** me permite descargar las imagenes sin complicaciones y con 1 línea de código.

## ¿Qué parte(s) de tu código pueden ser mejoradas si tuvieras más tiempo?

 - Diseño : Modo oscuro, reemplazar UITableView por UICollectionView para mejorar el diseño de las tarjetas de las series, implementar animaciones de carga, yo quitaría el UINavigationView y jugaría con la nueva forma en que se presentan los controladores (tipo dialogs)
 - Funcionalidad : notificaciones de nuevos capitulos en las series en emisión que estén en tus favoritos, listaría los episodios de la serie por temporadas, agregaría filtros de contenido por región, ya que la API lo permite. Guardaría imagenes y contenido para no depender en su mayoría de las peticiones y de que el usuario tenga una conexión a Internet.
 - Estructura: Revisaría mis recurrencias, minimizar el código donde se pueda, por ejemplo con los alerts que solicitaron para esta prueba, creo que puedo optimizar eso para no andar definiendo a diestra y siniestra nuevos alerts.

## ¿Cuáles fueron los mayores problemas que encontraste en el desarrollo de la práctica y cómo los resolviste?
Fue la primera vez que implementé pruebas unitarias, desconocía su estructura, su funcionalidad y su maravillosa implementación, me siento como cavernicola descubriendo el fuego. Me llevó un rato implementarlas, sin embargo la documentación en internet es vasta, considero que la mejor documentación está en ingles debido al auge que tiene en el extranjero. Todo lo que sé de programación tanto en Android como en iOS, me lo enseñó internet y la práctica diaria.
