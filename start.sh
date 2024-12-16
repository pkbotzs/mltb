source mltbenv/bin/activate
python3 update.py
python3 -m bot

from aiohttp import web
import pyrogram
from config import (
    BOT_UNAME,
    SHORTLINK_URL2,
    SHORTLINK_API2,
    CHANNEL_ID,
    IS_VERIFY,
)
from helper_func import get_shortlink, decode
from helper_func import User

routes = web.RouteTableDef()


@routes.get("/", allow_head=True)
async def root_route_handler(request):
    file_param = request.query.get("GET")
    hash = request.query.get("HASH")
    red_param = request.query.get("RED")

    if file_param and hash:
        if (
            ("ASHVER_" in file_param)
            or ("DBRE_" in file_param)
            or ("PRE_" in file_param)
        ):
            try:
                _, msgsstring = file_param.split("_", 1)
            except ValueError:
                return web.HTTPBadRequest(text="Invalid file_param format.")

            try:
                base64_string = (
                    msgsstring.split(" ", 1)[1] if " " in msgsstring else msgsstring
                )
            except IndexError:
                return web.HTTPBadRequest(text="Invalid base64 string.")

            # Decode and process the rest
            _string = await decode(base64_string)
            argument = _string.split("-")

            if len(argument) == 2:
                try:
                    message_id = int(int(argument[1]) / abs(CHANNEL_ID))
                except (ValueError, ZeroDivisionError):
                    return web.HTTPBadRequest(text="Invalid message ID.")
            else:
                return web.HTTPBadRequest(text="Invalid argument format.")

        elif (
            "ASHVER_" not in file_param
            and "DBRE_" not in file_param
            and "PRE_" not in file_param
        ) and len(file_param) > 7:
            try:
                base64_string = (
                    file_param.split(" ", 1)[1] if " " in file_param else file_param
                )
            except IndexError:
                return web.HTTPBadRequest(text="Invalid file_param format.")

            _string = await decode(base64_string)
            argument = _string.split("-")

            if len(argument) == 2:
                try:
                    message_id = int(int(argument[1]) / abs(CHANNEL_ID))
                except (ValueError, ZeroDivisionError):
                    return web.HTTPBadRequest(text="Invalid message ID.")
            else:
                return web.HTTPBadRequest(text="Invalid argument format.")

        tg_url = f"https://t.me/{BOT_UNAME}?start={base64_string}"
        prem_tg_url = f"https://t.me/{BOT_UNAME}?start=PRE_{base64_string}"

        tg_url_short = await get_shortlink(SHORTLINK_URL2, SHORTLINK_API2, tg_url)

        html_content = f"""
        <!DOCTYPE html>
        <html>
          <head>
            <title>Thiraihdq | Telegram</title>
            <link rel="icon" href="https://i.ibb.co/yNq8CXm/multimedia.png" type="image/x-icon"/>
            <link rel="shortcut icon" href="https://i.ibb.co/yNq8CXm/multimedia.png" type="image/x-icon" />
            <meta charset="utf-8" />
            <link rel="icon" href="assets/title.ico" />
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <link rel="preconnect" href="https://fonts.googleapis.com" />
            <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
            <link
              href="https://fonts.googleapis.com/css2?family=Poppins:wght@100;200;300;400;600;700&display=swap"
              rel="stylesheet"
            />
            <style>
              * {{
                font-family: "Poppins", sans-serif;
              }}

              body {{
                background: #4027ff;
                color: #ffffff;
                font: 1em/1.5 sans-serif;
                height: auto;
                display: flex;
                align-items: center;
                justify-content: center;
                margin: 0;
              }}

              .contents {{
                display: flex;
                flex-direction: column;
                justify-content: center;
                align-items: center;
                margin: 2rem;
                gap: 2rem;
              }}

              ::-webkit-scrollbar {{
                height: 0.5rem;
                width: 0.5rem;
              }}

              ::-webkit-scrollbar-track {{
                background-color: transparent;
              }}

              ::-webkit-scrollbar-thumb {{
                background-color: transparent;
              }}

              h1,h4 {{
                color: aliceblue;
              }}

              @media screen and (max-width: 700px) {{
                .btn {{
                  font-size: 1rem;
                  text-align: center;
                }}

                .btn2 {{
                  font-size: 0.7rem;
                  text-align: center;
                }}
              }}

              @-webkit-keyframes anime {{
                0% {{
                  background-position: 0% 50%;
                }}
                50% {{
                  background-position: 100% 50%;
                }}
                100% {{
                  background-position: 0% 50%;
                }}
              }}

              @keyframes anime {{
                0% {{
                  background-position: 0% 50%;
                }}
                50% {{
                  background-position: 100% 50%;
                }}
                100% {{
                  background-position: 0% 50%;
                }}
              }}

              .btn {{
                width: 300px;
                height: 50px;
                font-size: 12px;
                text-align: center;
                line-height: 50px;
                color: rgba(255, 255, 255, 0.9);
                border-radius: 50px;
                background: linear-gradient(-45deg, #ffa63d, #ff3d77, #338aff, #3cf0c5);
                background-size: 300%;
                -webkit-animation: anime 16s linear infinite;
                animation: anime 16s linear infinite;
                cursor: pointer;
                border: none;
              }}

              .btn2 {{
                position: absolute;
                margin-top: -10px;
                z-index: -1;
                filter: blur(30px);
                opacity: 0.8;
              }}

              button {{
                background: none;
                border: none;
                color: #ffffffe6;
                cursor: pointer;
              }}
            </style>
          </head>
          <body>
            <div class="contents">
              <h1>Thirai HDQ</h1>
                <button onclick="window.open('{tg_url_short}', '_blank')">
                  <div class="btn">
                      𝐆𝐞𝐭 𝐓𝐞𝐥𝐞𝐠𝐫𝐚𝐦 𝐅𝐢𝐥𝐞
                    <div class="btn2"></div>
                  </div>
                </button>
                <h4>Only Premium User</h4>
                <button onclick="window.open('{prem_tg_url}', '_blank')">
                <div class="btn">
                    𝐆𝐞𝐭 𝐅𝐢𝐥𝐞
                  <div class="btn2"></div>
                </div>
                </button>
              <h4>Buy Here Premium - Add Free</h4>
                <button onclick="window.open('https://t.me/+hjI3IucdWT01ZTA1', '_blank')">
                <div class="btn">
                    𝐂𝐨𝐧𝐭𝐚𝐜𝐭
                  <div class="btn2"></div>
                </div>
                </button>
              <br><br>
              <button onclick="window.open('https://t.me/+hjI3IucdWT01ZTA1', '_blank')">
                𝐏𝐨𝐰𝐞𝐫𝐞𝐝 𝐁𝐲 𝐓𝐡𝐢𝐫𝐚𝐢 𝐎𝐟𝐟𝐢𝐜𝐢𝐚𝐥
              </button>
            </div>
          </body>
        </html>
        """

        return web.Response(text=html_content, content_type="text/html")
    elif not file_param and not hash and red_param:
        url = await decode(red_param)

        final_url = await get_shortlink(SHORTLINK_URL2, SHORTLINK_API2, url)
        return web.HTTPFound(location=final_url)

    elif file_param and not hash and not red_param:
        open_url = f"https://t.me/{BOT_UNAME}?start={file_param}"

        return web.HTTPFound(location=open_url)

    else:
        return web.HTTPFound(location="https://t.me/itsme_kp")
