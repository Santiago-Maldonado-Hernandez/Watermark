function w_mark = deteccion(filename, c)
    %DESMARCAR Deteccion de marca de agua de un archivo filename
    % Leemos la imagen   
    etsit_marcada = double(imread(filename));
    
    % Normalizamos al imagen
    etsit_marcada = etsit_marcada/256;
    
    %Definimos los coeficientes del filtro W(z) = 1-0.99z^(-1)
    a = 1;
    b = [1 -0.99];
    
    % Variables de tamaño
    [m, n] = size(etsit_marcada);

    % Definimos la imagen marcada en un vector de una sola fila
    etsit_marcada_v = reshape(etsit_marcada, [1 m*n]); 
    
    % Filtramos la imagen y la secuencia pseudoaleatoria
    c_filter = filter(b, a, c);
    etsit_filter = filter(b, a, etsit_marcada_v);
    
    %longitud del vector logo de la tarea1
    L = 103400;

    % Definimos un vector de todo ceros del tamaño de la marca de agua
    w_mark = zeros(1, L);
    
    % Se realiza una correlación entre la imagen filtrada y la secuancia 
    % pseudoaleatoria filtrada. Si el resultado es >= 0 se decide que el 
    % bit de marca es 1, si es <0 se decide que el bit de marca es 0
    for i=1:L
        aux = etsit_filter(((i-1)*63 + 1):(i*63))*c_filter;
        if aux < 0
            w_mark(i) = 0;
        else 
            w_mark(i) = 1;
        end 
    end 
    
    % Redefinimos el vector para que sea del mismo tamaño 
    w_mark1 = reshape(w_mark, [200 517]);
    
    % Dibujamos la imagen marcada y la marca de agua
    subplot(2, 1, 1);
    imagesc(etsit_marcada);
    title('Imagen marcada');
    subplot(2, 1, 2);
    imagesc(w_mark1);
    title('Logo');
    colormap('gray');

end

