function phase = myphase(v10,v11)
    phase = acos(dot(v10,v11)/(norm(v10)*norm(v11)));
    if (phase < 0)
        phase = phase + 2*pi;
    end
end