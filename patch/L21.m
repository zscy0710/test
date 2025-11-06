function val = L21(W)
% L21   行稀疏范数  ‖W‖₂,₁ = ∑ₖ √∑ⱼ W(k,j)²
% W : d × c  (d 行特征，c 列类别)
val = sum( sqrt( sum(W.^2, 2 ) ) );
end