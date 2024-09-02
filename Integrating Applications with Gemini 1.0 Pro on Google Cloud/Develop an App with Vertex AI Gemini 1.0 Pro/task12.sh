cat >> ~/gemini-app/app_tab4.py <<EOF

    with video_highlights:
        video_highlights_uri = "gs://cloud-training/OCBL447/gemini-app/videos/pixel8.mp4"
        video_highlights_url = "https://storage.googleapis.com/"+video_highlights_uri.split("gs://")[1]

        video_highlights_vid = Part.from_uri(video_highlights_uri, mime_type="video/mp4")
        st.video(video_highlights_url)
        st.write("Generate highlights for the video.")

        prompt = """Answer the following questions using the video only:
                What is the profession of the girl in this video?
                Which features of the phone are highlighted here?
                Summarize the video in one paragraph.
                Write these questions and their answers in table format. 
                """

        tab1, tab2 = st.tabs(["Response", "Prompt"])
        video_highlights_description = st.button("Generate video highlights", key="video_highlights_description")
        with tab1:
            if video_highlights_description and prompt: 
                with st.spinner("Generating video highlights"):
                    response = get_gemini_pro_vision_response(multimodal_model_pro, [prompt, video_highlights_vid])
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
