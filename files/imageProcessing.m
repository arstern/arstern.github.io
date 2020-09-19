function imageProcessing (imageLocation)
image = imread(imageLocation);

%image display
f=figure('Name', 'Image Processing', 'Visible', 'On', 'Position', [300, 55, 805, 150]); %initiate figure window
set(f, 'Resize', 'off')
figure();
imshow(image, 'Border', 'Tight');

%gui components - spatial
reset = uicontrol(f, 'Style','pushbutton', 'Position', [5 10 100 30], 'String', 'Reset','Callback',@reset_Callback);
%reduceFreq = uicontrol(f, 'Style','pushbutton', 'Position', [105 10 100 30], 'String', 'Reduce Frequencies','Callback',@reduceNumberFrequencyComponents_Callback);
spatial=annotation(f, 'textbox', [0, .87, .2, .1], 'String', 'Spatial Domain:','EdgeColor','none');
spatialBlur = uicontrol(f, 'Style','pushbutton', 'Position', [105 120 100 30],'String', 'Blur','Callback',@spatialBlur_Callback);
spatial=annotation(f, 'textbox', [.13, .7, .2, .1], 'String', 'Select Radius:','EdgeColor','none');
enterBlurRadius=uicontrol(f, 'Style','edit','Position',[175 102 20 20], 'Callback', @enterBlurRadius_Callback);
spatialSharpen = uicontrol(f, 'Style','pushbutton', 'Position', [205 120 100 30],'String', 'Sharpen','Callback',@spatialSharpen_Callback);
spatialEdgeDetection = uicontrol(f, 'Style','pushbutton', 'Position', [305 120 100 30],'String', 'Detect Edges','Callback',@edgeDetection_Callback);
spatialEmboss = uicontrol(f, 'Style','pushbutton', 'Position', [405 120 100 30],'String', 'Emboss','Callback',@emboss_Callback);

%gui components - frequency
frequency=annotation(f, 'textbox', [0, .39, .15, .2], 'String', 'Frequency Domain:','EdgeColor','none');
FFT = uicontrol(f, 'Style','pushbutton', 'Position', [105 65 100 30],'String', 'FFT2','Callback',@fftBandW_Callback);
FFT_Magnitude = uicontrol(f, 'Style','pushbutton', 'Position', [205 65 100 30],'String', 'FFT Magnitude','Callback',@fftBandW_Magnitude_Callback);
FFT_Phase = uicontrol(f, 'Style','pushbutton', 'Position', [305 65 100 30],'String', 'FFT Phase','Callback',@fftBandW_Phase_Callback);
FFT_Mag_Reconstruct = uicontrol(f, 'Style','pushbutton', 'Position', [405 65 100 30],'String', 'Reconstruct Mag','Callback',@fft_Mag_Reconstruct_Callback);
FFT_Mag_Reconstruct = uicontrol(f, 'Style','pushbutton', 'Position', [505 65 100 30],'String', 'Reconstruct Phase','Callback',@fft_Phase_Reconstruct_Callback);
FFT_Blur = uicontrol(f, 'Style','pushbutton', 'Position', [605 65 100 30],'String', 'Blur','Callback',@fft_Blur_Callback);
blurFilter=annotation(f, 'textbox', [.755, .26, .1, .2], 'String', 'Select Filter Size:','EdgeColor','none');
enterBlurFilter=uicontrol(f, 'Style','edit','Position',[670 44 20 20], 'Callback', @enterBlurFilter_Callback);
FFT_Shapen = uicontrol(f, 'Style','pushbutton', 'Position', [705 65 100 30],'String', 'Detect Edges','Callback',@fft_Edges_Callback);
sharpenFilter=annotation(f, 'textbox', [.88, .26, .1, .2], 'String', 'Select Filter Size:','EdgeColor','none');
enterSharpenFilter=uicontrol(f, 'Style','edit','Position',[770 44 20 20], 'Callback', @enterSharpenFilter_Callback);

%global variables
blurRadius = 3;
[M, N]=size(rgb2gray(image));
blurFilterSize = min(0.5*M-1, 0.5*N-1) - 3*min(0.5*M-1, 0.5*N-1)/4 ;
sharpenFilterSize = min(0.5*M-1, 0.5*N-1) -  3*min(0.5*M-1, 0.5*N-1)/4;

%editing functions
    function reset_Callback(hObject, eventdata, handles)
        figure()
        imshow(image, 'Border', 'Tight');
    end

    function spatialBlur_Callback(hObject, eventdata, handles)
        dimension = blurRadius*2+1;
        kernel=1/(dimension^2)*ones(dimension, dimension);
        image_blurred_R = conv2(image(:, :, 1),kernel, 'valid');
        image_blurred_G = conv2(image(:, :, 2),kernel, 'valid');
        image_blurred_B = conv2(image(:, :, 3),kernel, 'valid');
        result = cat(3, uint8(image_blurred_R), uint8(image_blurred_G), uint8(image_blurred_B));
        figure()
        imshow(result, 'Border', 'Tight');
    end

    function enterBlurRadius_Callback(hObject, eventdata, handles)
        input = get(hObject, 'String');
        blurRadius = str2num(input);
    end

    function spatialSharpen_Callback(hObject, eventdata, handles)
        kernel =[0   -1   0; -1   5   -1; 0   -1   0];
        image_sharpened_R = conv2(image(:, :, 1),kernel, 'valid');
        image_sharpened_G = conv2(image(:, :, 2),kernel, 'valid');
        image_sharpened_B = conv2(image(:, :, 3),kernel, 'valid');
        result = cat(3, uint8(image_sharpened_R), uint8(image_sharpened_G), uint8(image_sharpened_B));
        figure()
        imshow(result, 'Border', 'Tight');
    end

    function edgeDetection_Callback(hObject, eventdata, handles)
        kernel =[1   0   -1; 0   0   0; -1   0   1];
        image_edges_R = conv2(image(:, :, 1),kernel, 'valid');
        image_edges_G = conv2(image(:, :, 2),kernel, 'valid');
        image_edges_B = conv2(image(:, :, 3),kernel, 'valid');
        result = cat(3, uint8(image_edges_R), uint8(image_edges_G), uint8(image_edges_B));
        figure()
        imshow(result, 'Border', 'Tight');
    end

    function emboss_Callback(hObject, eventdata, handles)
        kernel =[-2   -1   0; -1   1   1; 0   1  2];
        image_edges_R = conv2(image(:, :, 1),kernel, 'valid');
        image_edges_G = conv2(image(:, :, 2),kernel, 'valid');
        image_edges_B = conv2(image(:, :, 3),kernel, 'valid');
        result = cat(3, uint8(image_edges_R), uint8(image_edges_G), uint8(image_edges_B));
        figure()
        imshow(result, 'Border', 'Tight');
    end

    function fftBandW_Callback(hObject, eventdata, handles)
        result = fftshift(fft2(double(rgb2gray(image))));
        figure()
        imshow(result, 'Border', 'Tight');
    end

    function fftBandW_Magnitude_Callback(hObject, eventdata, handles)
        result = abs(fftshift(fft2(double(rgb2gray(image)))));
        figure()
        imshow(result,[-12 700000], 'Border', 'Tight') , colormap gray
    end

    function fftBandW_Phase_Callback(hObject, eventdata, handles)
        result = angle(fftshift(fft2(rgb2gray(image))));
        figure()
        imshow(result, 'Border', 'Tight') , colormap gray
    end

    function fft_Mag_Reconstruct_Callback(hObject, eventdata, handles)
        IM=rgb2gray(image);
        FF = abs(fft2(IM));
        IFF = ifft2(FF);
        FINAL_IM = uint8(real(IFF));
        I_Mag_min = min(min(abs(FINAL_IM)));
        I_Mag_max = max(max(abs(FINAL_IM)));
        figure
        imshow(abs(FINAL_IM),[I_Mag_min I_Mag_max], 'Border', 'Tight'), colormap gray
    end 

    function fft_Phase_Reconstruct_Callback(hObject, eventdata, handles)
        IM=rgb2gray(image);
        FF = angle(fft2(IM));
        IFF = ifft2(FF);
        FINAL_IM = (imag(IFF));
        I_Phase_min = min(min(abs(FINAL_IM)));
        I_Phase_max = max(max(abs(FINAL_IM)));
        figure
        imshow(abs(FINAL_IM),[I_Phase_min I_Phase_max], 'Border', 'Tight'), colormap gray
    end 

    function fft_Blur_Callback(hObject, eventdata, handles)
        if blurFilterSize > min(0.5*M-1, 0.5*N-1)
            blurFilterSize = min(0.5*M-1, 0.5*N-1);
        end
        D = blurFilterSize;
        LPF = zeros(M,N);
        LPF(0.5*M-D:0.5*M+D,0.5*N-D:0.5*N+D)=1;
        LPF_image_freq_domain_R=fftshift(fft2(double((image(:, :, 1))))).*LPF;
        LPF_image_freq_domain_G=fftshift(fft2(double((image(:, :, 2))))).*LPF;
        LPF_image_freq_domain_B=fftshift(fft2(double((image(:, :, 3))))).*LPF;
        result_R=ifft2(ifftshift(LPF_image_freq_domain_R));
        result_G=ifft2(ifftshift(LPF_image_freq_domain_G));
        result_B=ifft2(ifftshift(LPF_image_freq_domain_B));
        result = cat(3, uint8(result_R), uint8(result_G), uint8(result_B));
        figure()
        imshow(result, [12 290], 'Border', 'Tight'), colormap gray
    end


    function enterBlurFilter_Callback(hObject, eventdata, handles)
        input = get(hObject, 'String');
        blurFilterSize = str2num(input);
    end


    function enterSharpenFilter_Callback(hObject, eventdata, handles)
        input = get(hObject, 'String');
        sharpenFilterSize = str2num(input);
    end

  function fft_Edges_Callback(hObject, eventdata, handles)        
        if sharpenFilterSize > min(0.5*M-1, 0.5*N-1)
            sharpenFilterSize = min(0.5*M-1, 0.5*N-1);
        end
        D = sharpenFilterSize; 
        HPF = ones(M,N);
        HPF(0.5*M-D:0.5*M+D,0.5*N-D:0.5*N+D)=0;
        HPF_image_freq_domain_R=fftshift(fft2(double((image(:, :, 1))))).*HPF;
        HPF_image_freq_domain_G=fftshift(fft2(double((image(:, :, 2))))).*HPF;
        HPF_image_freq_domain_B=fftshift(fft2(double((image(:, :, 3))))).*HPF;
        result_R=ifft2(ifftshift(HPF_image_freq_domain_R));
        result_G=ifft2(ifftshift(HPF_image_freq_domain_G));
        result_B=ifft2(ifftshift(HPF_image_freq_domain_B));
        result = cat(3, uint8(result_R), uint8(result_G), uint8(result_B));
        figure()
        imshow(result, [12 290], 'Border', 'Tight'), colormap gray
  end

end