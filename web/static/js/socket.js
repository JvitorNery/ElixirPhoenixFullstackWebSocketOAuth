import {Socket} from "phoenix"
let socket = new Socket("/socket", {params: {token: window.userToken}})

socket.connect()

const createSocket = (topicId) => {
  let channel = socket.channel(`comments:${topicId}`, {})
  channel.join()
    .receive("ok", resp => {
      renderComments(resp.comments)
    })
    .receive("error", resp => {
      console.log("Unable to join", resp)
    })

    channel.on(`comments:${topicId}:new`, renderComment);

    document.querySelector('button').addEventListener('click', () => {
      const content = document.querySelector('textarea').value;
      document.querySelector('textarea').value = '';
      channel.push('comment:add', {content: content});
    });
}

function renderComments(comments) {
  const renderedComments = comments.map(comment => {
    return commentTemplate(comment);
  });

  document.querySelector('.collection').innerHTML = renderedComments.join('');
}

function renderComment(event) {
  const renderedComment = commentTemplate(event.comment);

  document.querySelector('.collection').innerHTML += renderedComment;  
}

function commentTemplate(comment) {
  return `
  <li class="collection-item">
    <div class="justify-content-start">
      <div class="">
        <img src="${comment.user.avatar}" class="avatar-comment" alt="${comment.user.name} avatar"/>
      </div>
      <div class="text-section">
        <span>${comment.user.name}</span> - <span>${comment.user.email}</span><br>
        <span>${comment.content}</span>
      </div>
    </div>
  </li>
`;
}

window.createSocket = createSocket;


