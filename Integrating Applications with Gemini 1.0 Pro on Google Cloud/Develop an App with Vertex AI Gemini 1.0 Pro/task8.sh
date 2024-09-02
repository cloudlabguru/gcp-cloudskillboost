cat >> ~/gemini-app/app_tab3.py <<EOF

    with diagrams:
        er_diag_uri = "gs://cloud-training/OCBL447/gemini-app/images/er.png"
        er_diag_url = "https://storage.googleapis.com/"+er_diag_uri.split("gs://")[1]

        er_diag_img = Part.from_uri(er_diag_uri,mime_type="image/png")
        st.image(er_diag_url, width=350, caption="Image of an ER diagram")
        st.write("Document the entities and relationships in this ER diagram.")

        prompt = """Document the entities and relationships in this ER diagram."""

        tab1, tab2 = st.tabs(["Response", "Prompt"])
        er_diag_img_description = st.button("Generate documentation", key="er_diag_img_description")
        with tab1:
            if er_diag_img_description and prompt: 
                with st.spinner("Generating..."):
                    response = get_gemini_pro_vision_response(multimodal_model_pro,[er_diag_img,prompt])
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
