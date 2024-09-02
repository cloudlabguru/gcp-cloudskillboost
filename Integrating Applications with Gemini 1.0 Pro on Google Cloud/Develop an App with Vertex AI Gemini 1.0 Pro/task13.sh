cat >> ~/gemini-app/app_tab4.py <<EOF

    with video_geoloc:
        video_geolocation_uri = "gs://cloud-training/OCBL447/gemini-app/videos/bus.mp4"
        video_geolocation_url = "https://storage.googleapis.com/"+video_geolocation_uri.split("gs://")[1]

        video_geolocation_vid = Part.from_uri(video_geolocation_uri, mime_type="video/mp4")
        st.video(video_geolocation_url)
        st.markdown("""Answer the following questions from the video:
                    - What is this video about?
                    - How do you know which city it is?
                    - What street is this?
                    - What is the nearest intersection?
                    """)

        prompt = """Answer the following questions using the video only:
                What is this video about?
                How do you know which city it is?
                What street is this?
                What is the nearest intersection?
                Answer the following questions using a table format with the questions and answers as columns. 
                """

        tab1, tab2 = st.tabs(["Response", "Prompt"])
        video_geolocation_description = st.button("Generate", key="video_geolocation_description")
        with tab1:
            if video_geolocation_description and prompt: 
                with st.spinner("Generating location information"):
                    response = get_gemini_pro_vision_response(multimodal_model_pro, [prompt, video_geolocation_vid])
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
