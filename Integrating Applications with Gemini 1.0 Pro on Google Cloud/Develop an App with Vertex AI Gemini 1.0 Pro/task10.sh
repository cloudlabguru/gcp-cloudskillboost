cat > ~/gemini-app/app_tab4.py <<EOF
import streamlit as st
from vertexai.preview.generative_models import GenerativeModel, Part
from response_utils import *
import logging

# render the Video Playground tab with multiple child tabs
def render_video_playground_tab(multimodal_model_pro: GenerativeModel):

    st.write("Using Gemini 1.0 Pro Vision - Multimodal model")
    video_desc, video_tags, video_highlights, video_geoloc = st.tabs(["Video description", "Video tags", "Video highlights", "Video geolocation"])

    with video_desc:
        video_desc_uri = "gs://cloud-training/OCBL447/gemini-app/videos/mediterraneansea.mp4"
        video_desc_url = "https://storage.googleapis.com/"+video_desc_uri.split("gs://")[1]            

        video_desc_vid = Part.from_uri(video_desc_uri, mime_type="video/mp4")
        st.video(video_desc_url)
        st.write("Generate a description of the video.")

        prompt = """Describe what is happening in the video and answer the following questions: \n
                - What am I looking at?
                - Where should I go to see it?
                - What are other top 5 places in the world that look like this? 
                """

        tab1, tab2 = st.tabs(["Response", "Prompt"])
        video_desc_description = st.button("Generate video description", key="video_desc_description")
        with tab1:
            if video_desc_description and prompt: 
                with st.spinner("Generating video description"):
                    response = get_gemini_pro_vision_response(multimodal_model_pro, [prompt, video_desc_vid])
                    st.markdown(response)
                    logging.info(response)
        with tab2:
            st.write("Prompt used:")
            st.write(prompt,"\n","{video_data}")

EOF

cat >> ~/gemini-app/app.py <<EOF

from app_tab4 import render_video_playground_tab

with tab4:
    render_video_playground_tab(multimodal_model_pro)

EOF

streamlit run app.py \
--browser.serverAddress=localhost \
--server.enableCORS=false \
--server.enableXsrfProtection=false \
--server.port 8080
