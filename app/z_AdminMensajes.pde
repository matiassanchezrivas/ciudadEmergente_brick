class AdminMensajes {

  ArrayList <Blob> blobsNuevos;
  ArrayList <Blob> blobsAnteriores;
  ArrayList <Blob> blobsAuxiliar;

  int punterosActuales[];
  int punterosAnteriores[];
  int cantidadMaximaDePunteros;

  boolean punterosEntrantes[];
  boolean punterosSalientes[];
  boolean punterosPresentes[];

  Blob blob;

  OscMessage mensajeConDatosDeBlob;


  int cantidadDeBlobsEsperados;
  int cantidadDeBlobsQueLlegaron;
  int cantidadMinimaDePuntos =  10;

  boolean inicioListaDeBlobs;
  boolean finListaDeBlobs;
  boolean permitirNuevosMensajes;

  boolean print;

  String address; // etiqueta de OSC por donde ingresan los mensajes desde la kinect ej /BFollowKinect/Manos

    boolean enviarMensajes; // envía mensajes hacia PD. Poner en false en el constructor de la silueta y en true en las manos.

  AdminMensajes( String _address, boolean _enviarMensajes, boolean _print ) {

    blobsAuxiliar = new ArrayList();
    blobsNuevos = null;
    blobsAnteriores = null;

    cantidadMaximaDePunteros = 1000;

    punterosAnteriores = new int[cantidadMaximaDePunteros];
    punterosActuales = new int[cantidadMaximaDePunteros];
    punterosEntrantes = new boolean[cantidadMaximaDePunteros];
    punterosSalientes = new boolean[cantidadMaximaDePunteros];
    punterosPresentes = new boolean[cantidadMaximaDePunteros];

    for (int i=0; i<cantidadMaximaDePunteros; i++) {

      punterosAnteriores[i] = 0;
      punterosActuales[i] = 0;
      punterosEntrantes[i] = false;
      punterosSalientes[i] = false;
      punterosPresentes[i] = false;
    }

    cantidadDeBlobsEsperados = 0;
    cantidadDeBlobsQueLlegaron = 0;

    inicioListaDeBlobs = false;
    finListaDeBlobs = false;
    permitirNuevosMensajes = true;

    mensajeConDatosDeBlob = null;

    blob = null;

    address = _address;

    enviarMensajes = _enviarMensajes;

    print = _print;
  }

  //---------------------------------
  void actualizar() {

    if (finListaDeBlobs) {
      copiarListaBlobsNuevosEnListaBlobsAnteriores();
      copiarListaAuxiliarEnListaBlobsNuevos();
      actualizarEstadosDePunteros();
      if (enviarMensajes) enviarMensajesDePunteros();
      finListaDeBlobs = false;
      permitirNuevosMensajes = true;
    }
  }

  //---------------------------------
  void recibeMensaje(OscMessage theOscMessage) {

    if (permitirNuevosMensajes) {

      if (theOscMessage.checkAddrPattern(address + "/init")) {

        if (theOscMessage.checkTypetag("i")) {

          cantidadDeBlobsEsperados = theOscMessage.get(0).intValue();

          borrarListaAuxiliar();

          inicializarPunteros();  // copia los blobs actuales en los anteriores y pone en 0 los actuales
          inicializarEstadosDePunteros(); // poner los punteros entrantes, salientes y presentes en false
          if (cantidadDeBlobsEsperados == 0) {
            borrarListaBlobsNuevos();
            if (print) println("--->OSC---> -------------INIT ----------- 0 BLOBS ");
            actualizarEstadosDePunteros();
            if (enviarMensajes) enviarMensajesDePunteros();
          } else {
            if (print) println("--->OSC---> INIT");
          }

          inicioListaDeBlobs = true;
        }
      }

      if (theOscMessage.checkAddrPattern(address+"/newBlob")) { 

        if (inicioListaDeBlobs) {
          mensajeConDatosDeBlob = theOscMessage;

          if (print) println("--->OSC---> ---NEW BLOB---");

          blob = new Blob();

          if (cargarDatosEnBlob(mensajeConDatosDeBlob, blob)) { // si pudo cargar los datos en el blob

              incluirBlobEnListaAuxiliar(blob); // agrega el blob nuevo en la lista auxiliar de blobs
            actualizarPunteros(blob); // punterosActuales[indice] = 1;

            if (print) println("BLOBS DENTRO DE LA LISTA AUX: " + blobsAuxiliar.size());
          } else {
            if (print) println("NO SE PUDO INCLUIR BLOB!!!!: " + blobsAuxiliar.size());
          }
        }
      }

      if (theOscMessage.checkAddrPattern(address+"/end")) {

        if (inicioListaDeBlobs) {

          inicioListaDeBlobs = false;
          finListaDeBlobs = true;
          permitirNuevosMensajes = false;

          if (print) println("--->OSC---> -------------END -----------");
        }
      }
    }
  }

  //---------------------------------
  boolean cargarDatosEnBlob( OscMessage theOscMessage, Blob nuevoBlob) {

    boolean datosCargados = false;

    if (theOscMessage != null && nuevoBlob != null && theOscMessage.arguments().length >= 18) {

      nuevoBlob.pid = theOscMessage.get(0).intValue();      
      nuevoBlob.oid = theOscMessage.get(1).intValue();
      nuevoBlob.age = theOscMessage.get(2).intValue();
      nuevoBlob.centroidX = theOscMessage.get(3).floatValue();
      nuevoBlob.centroidY = theOscMessage.get(4).floatValue();
      nuevoBlob.velocityX = theOscMessage.get(5).floatValue();
      nuevoBlob.velocityY = theOscMessage.get(6).floatValue();
      nuevoBlob.depth = theOscMessage.get(7).floatValue();
      nuevoBlob.boundingRectX = theOscMessage.get(8).floatValue();
      nuevoBlob.boundingRectY = theOscMessage.get(9).floatValue();
      nuevoBlob.boundingRectWidth = theOscMessage.get(10).floatValue();
      nuevoBlob.boundingRectHeight = theOscMessage.get(11).floatValue();
      nuevoBlob.area = theOscMessage.get(12).intValue();              
      nuevoBlob.highestX = theOscMessage.get(13).floatValue();          
      nuevoBlob.highestY = theOscMessage.get(14).floatValue();
      nuevoBlob.lowestX = theOscMessage.get(15).floatValue();
      nuevoBlob.lowestY = theOscMessage.get(16).floatValue();
      nuevoBlob.simpleContourSize = theOscMessage.get(17).intValue();

      if (blob.simpleContourSize >= cantidadMinimaDePuntos) {

        asignaContornoABlob(theOscMessage);
      }

      datosCargados = true;
    }

    return datosCargados;
  }

  //---------------------------------
  boolean elMensajeTieneContorno( OscMessage theOscMessage ) {

    boolean tieneContorno = false;

    if (theOscMessage.arguments().length >= 18 && 
      theOscMessage.get(17).intValue() >= cantidadMinimaDePuntos ) {
      tieneContorno = true;
    }

    return tieneContorno;
  }

  //---------------------------------
  void asignaContornoABlob( OscMessage theOscMessage ) {

    for (int i = 18; i < theOscMessage.arguments ().length; i += 2) {
      PVector point = new PVector();
      point.x = theOscMessage.get(i).floatValue();
      point.y = theOscMessage.get(i + 1).floatValue();
      blob.contours.add(point);
      //println("punto:  " + point.x);
    }
  }

  //---------------------------------
  void copiarListaBlobsNuevosEnListaBlobsAnteriores() {

    if (blobsNuevos != null) {
      blobsAnteriores = blobsNuevos;

      if (print) println("BLOBS DENTRO DE LA LISTA BLOBS ANTERIORES: " + blobsAnteriores.size());
    }
  }

  //---------------------------------
  void copiarListaAuxiliarEnListaBlobsNuevos() {

    blobsNuevos = blobsAuxiliar;

    if (print) println("BLOBS DENTRO DE LA LISTA BLOBS NUEVOS: " + blobsNuevos.size());

    blobsAuxiliar = new ArrayList();
  }

  //---------------------------------
  void incluirBlobEnListaAuxiliar(Blob nuevoBlob) {

    if (nuevoBlob != null) {
      blobsAuxiliar.add(nuevoBlob);
      if (print) println("INCLUYENDO BLOB[" + nuevoBlob.pid + "] en la lista auxiliar");
    }
  }

  //---------------------------------
  void borrarListaBlobsNuevos() {

    if (blobsNuevos != null) blobsNuevos.clear();
    if (print) println("borrando lista de blobs nuevos");
  }

  //---------------------------------
  void borrarListaAuxiliar() {

    blobsAuxiliar.clear();
  }

  //---------------------------------
  void inicializarEstadosDePunteros() {

    for (int i=0; i<cantidadMaximaDePunteros; i++) {

      punterosEntrantes[i] = false;
      punterosSalientes[i] = false;
      punterosPresentes[i] = false;
    }
  }

  //---------------------------------
  void inicializarPunteros() {

    for (int i=0; i<cantidadMaximaDePunteros; i++) {
      punterosAnteriores[i] = punterosActuales[i];
      punterosActuales[i] = 0;
    }
  }

  //---------------------------------
  void actualizarPunteros(Blob nuevoBlob) {

    if (nuevoBlob != null) {

      int indice = nuevoBlob.pid;

      punterosActuales[indice] = 1;

      if (print)println("actualizar puntero["+nuevoBlob.oid+"] id: "+nuevoBlob.pid);
    }
  }


  //---------------------------------
  void actualizarEstadosDePunteros() {

    for (int i=0; i<cantidadMaximaDePunteros; i++) {

      if (punterosActuales[i] == 1 && punterosAnteriores[i] == 0) { // si hay un nuevo puntero que no habìa antes -> punteroEntrante
        punterosEntrantes[i] = true;
      }
      if (punterosActuales[i] == 0 && punterosAnteriores[i] == 1) { // si un puntero actual que antes estaba se fue -> punteroSaliente
        punterosSalientes[i] = true;
      }
      if (punterosActuales[i] == 1 && punterosAnteriores[i] == 1) { // si un puntero aun esta presete -> punteroPresente
        punterosPresentes[i] = true;
      }
    }
  }

  //---------------------------------

  void enviarMensajesDePunteros() {

    for (int i=0; i<cantidadMaximaDePunteros; i++) {

      if (punterosEntrantes[i] == true) {
        if (print) println("<---OSC--ENVIANDO puntero entrante: " + i);
        Blob esteBlob = devolverBlobNuevoPorPid(i);
        enviarMesajePunteroEntrante(esteBlob.pid, esteBlob.oid, esteBlob.highestX, esteBlob.highestY, esteBlob.depth);
      } 
      if (punterosSalientes[i] == true) {
        if (print)println("<---OSC--ENVIANDO puntero saliente: " + i);
        Blob esteBlob = devolverBlobAnteriorPorPid(i);
        enviarMesajePunteroSaliente(esteBlob.pid, esteBlob.oid, esteBlob.highestX, esteBlob.highestY, esteBlob.depth);
        //enviarMesajePunteroSaliente(i);
      }
      if (punterosPresentes[i] == true) {
        if (print)println("<---OSC--ENVIANDO puntero presente: " + i);
        Blob esteBlob = devolverBlobNuevoPorPid(i);
        enviarMesajePunteroPresente(esteBlob.pid, esteBlob.oid, esteBlob.highestX, esteBlob.highestY, esteBlob.depth);
        //enviarMesajePunteroPresente(i);
      }
    }
  }

  //---------------------------------
  Blob devolverBlobNuevoPorPid(int pidBuscado) {

    Blob blobEncontrado = null;

    for (int i=0; i<blobsNuevos.size (); i++) {

      if (blobsNuevos.get(i).pid == pidBuscado) {
        blobEncontrado = blobsNuevos.get(i);
        if (print) println("blob nuevo encontrado["+blobEncontrado.oid+"] id: "+blobEncontrado.pid);
      }
    }
    return blobEncontrado;
  }

  //---------------------------------
  Blob devolverBlobAnteriorPorPid(int pidBuscado) {

    Blob blobEncontrado = null;

    for (int i=0; i<blobsAnteriores.size (); i++) {

      if (blobsAnteriores.get(i).pid == pidBuscado) {
        blobEncontrado = blobsAnteriores.get(i);
        if (print) println("blob anterior encontrado["+blobEncontrado.oid+"] id: "+blobEncontrado.pid);
      }
    }
    return blobEncontrado;
  }

  //---------------------------------

  void dibujarBlobs(float x, float y, float ancho, float alto) {

    if (blob != null) {

      if (print) println("dibujando [" +  blobsNuevos.size() + "] blobs ");

      for (int i=0; i<blobsNuevos.size (); i++) {

        //if (print) println("dibujando blob: " + i);
        blobsNuevos.get(i).dibujar(x, y, ancho, alto);
      }
    }
  }
  //---------------------------------

  ArrayList <Blob> entregarListaBlobs() { 
    return blobsNuevos;
  }
  //---------------------------------
}