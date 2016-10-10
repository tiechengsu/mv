function [Faces]=FaceDetection(faceData)
faceDector = vision.CascadeObjectDetector('FrontalFaceCART','MinSize',[80 80]);
Faces = {};
for i = 1:size(faceData,2)
    n = 1;
    Face = {};
    for j = 1:faceData(i).Count
        bbox = step(faceDector,read(faceData(i),j));
        if isempty(bbox) == 0
            I = imcrop(read(faceData(i),j),[bbox(1,1) bbox(1,2) bbox(1,3) bbox(1,4)]);
            scaleFactor = 150/size(I,1);
            I = imresize(I,scaleFactor);
            Face{n} = I;
            n = n+1;
        end
    end
    Faces{i}=Face;
end
end