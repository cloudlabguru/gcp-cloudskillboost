cat >> ~/gemini-app/app_tab3.py <<EOF

    with equations:
        math_image_uri = "gs://cloud-training/OCBL447/gemini-app/images/math_eqn.jpg"
        math_image_url = "https://storage.googleapis.com/"+math_image_uri.split("gs://")[1]

        math_image_img = Part.from_uri(math_image_uri,mime_type="image/jpeg")
        st.image(math_image_url,width=350, caption="Image of a math equation")
        st.markdown(f"""
                Ask questions about the math equation as follows: 
                - Extract the formula.
                - What is the symbol right before Pi? What does it mean?
                - Is this a famous formula? Does it have a name?
                    """)

        prompt = """Follow the instructions. Surround math expressions with $. Use a table with a row for each instruction and its result.
                INSTRUCTIONS:
                - Extract the formula.
                - What is the symbol right before Pi? What does it mean?
                - Is this a famous formula? Does it have a name?
                """

        tab1, tab2 = st.tabs(["Response", "Prompt"])
        math_image_description = st.button("Generate answers", key="math_image_description")
        with tab1:
            if math_image_description and prompt: 
                with st.spinner("Generating answers for formula using Gemini..."):
                    response = get_gemini_pro_vision_response(multimodal_model_pro, [math_image_img, prompt])
                    st.markdown(response)
                    logging.info(response)
        with tab2:
            st.write("Prompt used:")
            st.text(prompt)

EOF

streamlit run app.py \
--browser.serverAddress=localhost \
--server.enableCORS=false \
--server.enableXsrfProtection=false \
--server.port 8080
