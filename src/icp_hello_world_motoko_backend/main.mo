import Types "modules/types";
import Http "mo:base/Http";

actor {
  stable var images : [(Types.ImageId, Blob)] = [];

  // Función para subir una imagen
  public func uploadImage(image : Blob) : async Types.ImageId {
    let imageId = Array.length(images) + 1;
    images := Array.append(images, [(imageId, image)]);
    return imageId;
  };

  // Función para recuperar una imagen por su Id
  public func getImage(imageId : Types.ImageId) : async ?Blob {
    switch (Array.find(images, func (img : (Types.ImageId, Blob)) : Bool { img.1 == imageId })) {
      case (? (imageId, image)) {
        return image;
      };
      case null {
        return null;
      };
    };
  };

  // Servicio para manejar las solicitudes HTTP
  public func handleRequest(request : Http.Request) : async Http.Response {
    switch (request.method()) {
      case "POST" {
        switch (request.body()) {
          case opt body {
            let imageId = uploadImage(body);
            return Http.Response.ok(imageId);
          };
          case null {
            return Http.Response.error(400, "No se proporcionó el cuerpo de la solicitud");
          };
        };
      };
      case "GET" {
        // Manejamos la solicitud de recuperar una imagen GET
        switch (request.queryParam("imageId")) {
          case opt imageId {
            let image = await getImage(Types.ImageId.fromInt(imageId));
            return Http.Response.ok(image);
          };
          case null {
            return Http.Response.error(400, "No se proporcionó el Id de la imagen");
          };
        };
      };
      default {
        return Http.Response.error(405, "Método no permitido");
      };
    };
  };
};









