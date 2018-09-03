
boolean monitorOSCbitacora = false;

//-----------------------------------------
void enviarMesajePunteroEntrante(int pid, int oid, float x, float y, float z) {

  OscMessage myMessage = new OscMessage("/punteroEntrante");

  myMessage.add(pid);
  myMessage.add(oid);
  myMessage.add(x);
  myMessage.add(y);
  myMessage.add(z);

  oscSalida.send(myMessage, myRemoteLocation);
  //if ( monitorOSCbitacora ) Xprint("OSC->/punteroEntrante");
  
}

//-----------------------------------------
void enviarMesajePunteroSaliente(int pid, int oid, float x, float y, float z) {

  OscMessage myMessage = new OscMessage("/punteroSaliente");

  myMessage.add(pid);
  myMessage.add(oid);
  myMessage.add(x);
  myMessage.add(y);
  myMessage.add(z);

  oscSalida.send(myMessage, myRemoteLocation);
  //if ( monitorOSCbitacora ) Xprint("OSC->/punteroSaliente");
}

//-----------------------------------------
void enviarMesajePunteroPresente(int pid, int oid, float x, float y, float z) {

  OscMessage myMessage = new OscMessage("/punteroPresente");

  myMessage.add(pid);
  myMessage.add(oid);
  myMessage.add(x);
  myMessage.add(y);
  myMessage.add(z);

  oscSalida.send(myMessage, myRemoteLocation);
  //if ( monitorOSCbitacora ) Xprint("OSC->/punteroPresente");
}


//-----------------------------------------
void enviarDistancia(float distancia) {

  OscMessage myMessage = new OscMessage("/distancia");

  myMessage.add(distancia);

  oscSalida.send(myMessage, myRemoteLocation);
  //if ( monitorOSCbitacora ) Xprint("OSC->/distancia "+distancia);
}