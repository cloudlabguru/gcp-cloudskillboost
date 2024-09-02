cat >> ~/gemini-app/app_tab4.py <<EOF

    with video_tags:
        video_tags_uri = "gs://cloud-training/OCBL447/gemini-app/videos/photography.mp4"
        video_tags_url = "https://storage.googleapis.com/"+video_tags_uri.split("gs://")[1]

        video_tags_vid = Part.from_uri(video_tags_uri, mime_type="video/mp4")
        st.video(video_tags_url)
        st.write("Generate tags for the video.")

        prompt = """Answer the following questions using the video only:
                    1. What is in the video?
                    2. What objects are in the video?
                    3. What is the action in the video?
                    4. Provide 5 best tags for this video?
                    Write the answer in table format with the questions and answers in columns.
                """

        tab1, tab2 = st.tabs(["Response", "Prompt"])
        video_tags_desc = st.button("Generate video tags", key="video_tags_desc")
        with tab1:
            if video_tags_desc and prompt: 
                with st.spinner("Generating video tags"):
                    response = get_gemini_pro_vision_response(multimodal_model_pro, [prompt, video_tags_vid])
                    st.markdown(response)
                    logging.info(response)
        with tab2:
            st.write("Prompt used:")
            st.write(prompt,"\n","{video_data}")

EOF

streamlit run app.py \
--browser.serverAddress=localhost \
--server.enableCORS=false \
--server.enableXsrfProtection=false \
--server.port 8080
