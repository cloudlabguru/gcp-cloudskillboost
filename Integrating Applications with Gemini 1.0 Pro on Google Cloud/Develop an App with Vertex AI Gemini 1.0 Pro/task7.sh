cat >> ~/gemini-app/app_tab3.py <<EOF

    with screens:
        oven_screen_uri = "gs://cloud-training/OCBL447/gemini-app/images/oven.jpg"
        oven_screen_url = "https://storage.googleapis.com/"+oven_screen_uri.split("gs://")[1]

        oven_screen_img = Part.from_uri(oven_screen_uri, mime_type="image/jpeg")
        st.image(oven_screen_url, width=350, caption="Image of an oven control panel")
        st.write("Provide instructions for resetting the clock on this appliance in English")

        prompt = """How can I reset the clock on this appliance? Provide the instructions in English.
                If instructions include buttons, also explain where those buttons are physically located.
                """

        tab1, tab2 = st.tabs(["Response", "Prompt"])
        generate_instructions_description = st.button("Generate instructions", key="generate_instructions_description")
        with tab1:
            if generate_instructions_description and prompt: 
                with st.spinner("Generating instructions using Gemini..."):
                    response = get_gemini_pro_vision_response(multimodal_model_pro, [oven_screen_img, prompt])
                    st.markdown(response)
                    logging.info(response)
        with tab2:
            st.write("Prompt used:")
            st.text(prompt+"\n"+"input_image")
EOF

streamlit run app.py \
--browser.serverAddress=localhost \
--server.enableCORS=false \
--server.enableXsrfProtection=false \
--server.port 8080
