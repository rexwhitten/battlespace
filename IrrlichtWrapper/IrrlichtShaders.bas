''
'' An IrrlichtWrapper Interface Test
'' F.Dodd (2006)
''
'' This is a pure test of creating a wrapper DLL for Irrlicht simplifying its
'' C++ architecture and providing a basic but functional 3D SDK for languages
'' that are not object oriented. At the moment this provides very few calls and
'' is merely a test for implementing such an interface.
''
'' This source uses Irrlicht definitions created by the Irrlicht authors
''

'' ////////////////////////////////////////////////////////////////////////////
'' Variables used to pass values into the shaders
Dim Shared as integer constantZero  = 0
Dim Shared as integer constantOne   = 1
Dim Shared as integer constantTwo   = 2
Dim Shared as integer constantThree = 3


'' ////////////////////////////////////////////////////////////////////////////
'' Functions used to set up specific shaders

' Attach a shader to a node
'
Sub AttachShader( node as irr_node, shader as IRR_SHADER ptr )

    If shader <> 0 Then
        ' apply the shader to one of the objects
        IrrSetNodeMaterialType ( node, shader->material_type )

    End If

End Sub


' Load and compile the suplied standard GLSL basic material
'
Function AddBasicGLSLShader() as IRR_SHADER ptr

    ' the returned shader
    DIM shader as IRR_SHADER ptr = IRR_NO_OBJECT

    ' add the shader
    shader = IrrAddHighLevelShaderMaterialFromFiles( _
            "./media/glsl_basic_vert.txt", "main", EVST_VS_1_1, _
            "./media/glsl_basic_frag.txt", "main", EPST_PS_1_1, _
            IRR_EMT_SOLID )
    
    ' if a shader was created
    if shader = 0 then

        Print "Unable to create basic shader"

    else
        IrrCreateNamedVertexShaderConstant ( _
            shader, "myTexture", IRR_NO_PRESET, _
            cast( single ptr, @constantZero), 1 )

    end if

    return shader

End Function


' Load and compile the suplied GLSL Cell material
'
Function AddCellGLSLShader() as IRR_SHADER ptr

    ' the returned shader
    DIM shader as IRR_SHADER ptr = IRR_NO_OBJECT

    ' add the shader
    shader = IrrAddHighLevelShaderMaterialFromFiles( _
            "./media/glsl_cell_vert.txt", "main", EVST_VS_1_1, _
            "./media/glsl_cell_frag.txt", "main", EPST_PS_1_1, _
            IRR_EMT_SOLID )
    
    ' if a shader was created
    if shader = 0 then

        Print "Unable to create Cell shader"

    end if

    return shader

End Function


' Load and compile the suplied GLSL Clip material
'
Function AddClipGLSLShader() as IRR_SHADER ptr

    ' the returned shader
    DIM shader as IRR_SHADER ptr = IRR_NO_OBJECT

    ' add the shader
    shader = IrrAddHighLevelShaderMaterialFromFiles( _
            "./media/glsl_clipmap_vert.txt", "main", EVST_VS_1_1, _
            "./media/glsl_clipmap_frag.txt", "main", EPST_PS_1_1, _
            IRR_EMT_SOLID )
    
    ' if a shader was created
    if shader = 0 then

        Print "Unable to create Clip shader"

    else
        IrrCreateNamedVertexShaderConstant ( _
            shader, "myTexture", IRR_NO_PRESET, _
            cast( single ptr, @constantZero), 1 )
    end if

    return shader

End Function


' Load and compile the suplied GLSL ColorCube material
'
Function AddMultiTextureGLSLShader() as IRR_SHADER ptr

    ' the returned shader
    DIM shader as IRR_SHADER ptr = IRR_NO_OBJECT

    ' add the shader
    shader = IrrAddHighLevelShaderMaterialFromFiles( _
            "./media/glsl_multitexture_vert.txt", "main", EVST_VS_1_1, _
            "./media/glsl_multitexture_frag.txt", "main", EPST_PS_1_1, _
            IRR_EMT_SOLID )
    
    ' if a shader was created
    if shader = 0 then

        Print "Unable to create Multi-Texture shader"

    else
        IrrCreateNamedVertexShaderConstant ( _
            shader, "myTexture1", IRR_NO_PRESET, _
            cast( single ptr, @constantZero), 1 )

        IrrCreateNamedVertexShaderConstant ( _
            shader, "myTexture2", IRR_NO_PRESET, _
            cast( single ptr, @constantOne), 1 )

        IrrCreateNamedVertexShaderConstant ( _
            shader, "myTexture3", IRR_NO_PRESET, _
            cast( single ptr, @constantTwo), 1 )
    end if

    return shader

End Function


' Load and compile the suplied GLSL ColorCube material
'
Function AddTextureEmissiveGLSLShader() as IRR_SHADER ptr

    ' the returned shader
    DIM shader as IRR_SHADER ptr = IRR_NO_OBJECT

    ' add the shader
    shader = IrrAddHighLevelShaderMaterialFromFiles( _
            "./media/glsl_texture_emission_vert.txt", "main", EVST_VS_1_1, _
            "./media/glsl_texture_emission_frag.txt", "main", EPST_PS_1_1, _
            IRR_EMT_SOLID )
    
    ' if a shader was created
    if shader = 0 then

        Print "Unable to create Emissive-Texture shader"

    else
        IrrCreateNamedVertexShaderConstant ( _
            shader, "myTexture", IRR_NO_PRESET, _
            cast( single ptr, @constantZero), 1 )
    end if

    return shader

End Function
