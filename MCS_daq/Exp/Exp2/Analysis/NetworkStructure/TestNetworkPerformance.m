

CreateNeuronLocations
sig_t = [0.0125 0.025 0.05 0.1 0.2 0.4 0.8 1 2];
n_tries = 3;
test_r = zeros(numel(sig_t),n_tries);
conn =4;
trial=1;

for conn=1:numel(sig_t)
    sig = sig_t(conn);

    S = {};
    for trial=1:n_tries
        CreateRandomNetwork
        ResponseAnalyse
        %Ps Created
        [emin, Wmin] = CheckClassifiability(Ps,1:56,ones(121,56));

        S{trial}.W = Wv;
        S{trial}.A = A ;
        S{trial}.P = O ;
        S{trial}.emin = emin;
        test_r(conn,trial) = sum(emin/45<0.2);   
        test_r
        
        P = Ps;
        CheckGEN;
        S{trial}.erra=erra;
    end
    save(sprintf('Sim%1.4f.mat',sig),'S');
end
save('test_r.mat','sig_t','test_r')
